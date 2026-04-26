---
draft: false
date: 2026-04-26
tags: [AI, 基础, Transformer]
categories: [AI]
---

**论文**: [Attention Is All You Need](https://arxiv.org/abs/1706.03762)

**来源**: NeurIPS 2017 | Google Brain

**作者**: Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Lukasz Kaiser, Illia Polosukhin

![image-20260426135726053](https://img-1300769438.cos.ap-beijing.myqcloud.com/images/image-20260426135726053.png)

<!-- more -->

### 核心贡献

提出 **Transformer** 架构，完全基于注意力机制，摒弃 RNN/LSTM，实现并行训练。

---

### 架构组成

#### 编码器 (Encoder)

- 6 层相同结构堆叠
- 每层：多头自注意力 + 前馈网络
- 残差连接 + 层归一化

#### 解码器 (Decoder)

- 6 层相同结构堆叠
- 每层：掩码多头自注意力 + 编码器-解码器注意力 + 前馈网络
- **掩码机制**：防止看到未来 token

---

### 注意力机制

**Scaled Dot-Product Attention**：

$$
\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right)V
$$

**Multi-Head Attention**：

$$
\text{MultiHead} = \text{Concat}(\text{head}_1, \ldots, \text{head}_h)W^O
$$

$$
\text{head}_i = \text{Attention}(QW_i^Q, KW_i^K, VW_i^V)
$$

将输入分成多个头并行计算注意力，捕捉不同类型的依赖关系。

---

### 位置编码 (Positional Encoding)

使用正弦/余弦函数注入序列顺序信息：

$$
PE_{(pos, 2i)} = \sin\left(\frac{pos}{10000^{2i/d_{\text{model}}}}\right)
$$

$$
PE_{(pos, 2i+1)} = \cos\left(\frac{pos}{10000^{2i/d_{\text{model}}}}\right)
$$

---

### 代码实现

#### 位置编码

```python
class PositionalEncoding(nn.Module):
    def __init__(self, d_model, max_len=5000):
        super().__init__()
        pe = torch.zeros(max_len, d_model)
        position = torch.arange(0, max_len).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, d_model, 2) * (-math.log(10000.0) / d_model))
        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)
        self.register_buffer('pe', pe.unsqueeze(0))

    def forward(self, x):
        return x + self.pe[:, :x.size(1), :]
```

#### 多头注意力

```python
class MultiHeadAttention(nn.Module):
    def __init__(self, d_model, num_heads):
        super().__init__()
        assert d_model % num_heads == 0
        self.d_k = d_model // num_heads
        self.W_q = nn.Linear(d_model, d_model)
        self.W_k = nn.Linear(d_model, d_model)
        self.W_v = nn.Linear(d_model, d_model)
        self.W_o = nn.Linear(d_model, d_model)

    def forward(self, Q, K, V, mask=None):
        batch_size = Q.size(0)

        # 线性变换 + 分头
        Q = self.W_q(Q).view(batch_size, -1, 8, self.d_k).transpose(1, 2)
        K = self.W_k(K).view(batch_size, -1, 8, self.d_k).transpose(1, 2)
        V = self.W_v(V).view(batch_size, -1, 8, self.d_k).transpose(1, 2)

        # 注意力计算: softmax(QK^T / sqrt(d_k)) * V
        scores = torch.matmul(Q, K.transpose(-2, -1)) / math.sqrt(self.d_k)
        if mask is not None:
            scores = scores.masked_fill(mask == 0, float('-inf'))
        attn_weights = F.softmax(scores, dim=-1)
        context = torch.matmul(attn_weights, V)

        # 合并多头
        context = context.transpose(1, 2).contiguous().view(batch_size, -1, 512)
        return self.W_o(context)
```

#### 编码器层

```python
class EncoderLayer(nn.Module):
    def __init__(self, d_model, num_heads, d_ff=2048):
        super().__init__()
        self.self_attn = MultiHeadAttention(d_model, num_heads)
        self.feed_forward = nn.Sequential(
            nn.Linear(d_model, d_ff),
            nn.ReLU(),
            nn.Linear(d_ff, d_model)
        )
        self.norm1 = nn.LayerNorm(d_model)
        self.norm2 = nn.LayerNorm(d_model)

    def forward(self, x, mask=None):
        # 自注意力 + 残差连接
        attn_out = self.self_attn(x, x, x, mask)
        x = self.norm1(x + attn_out)
        # 前馈网络 + 残差连接
        ff_out = self.feed_forward(x)
        x = self.norm2(x + ff_out)
        return x
```

#### 解码器层

```python
class DecoderLayer(nn.Module):
    def __init__(self, d_model, num_heads, d_ff=2048):
        super().__init__()
        self.self_attn = MultiHeadAttention(d_model, num_heads)
        self.cross_attn = MultiHeadAttention(d_model, num_heads)
        self.feed_forward = nn.Sequential(
            nn.Linear(d_model, d_ff),
            nn.ReLU(),
            nn.Linear(d_ff, d_model)
        )
        self.norm1 = nn.LayerNorm(d_model)
        self.norm2 = nn.LayerNorm(d_model)
        self.norm3 = nn.LayerNorm(d_model)

    def forward(self, x, encoder_output, src_mask=None, tgt_mask=None):
        # 掩码自注意力（看不到未来token）
        self_out = self.self_attn(x, x, x, tgt_mask)
        x = self.norm1(x + self_out)
        # 交叉注意力（Query来自Decoder，K/V来自Encoder）
        cross_out = self.cross_attn(x, encoder_output, encoder_output, src_mask)
        x = self.norm2(x + cross_out)
        # 前馈网络
        ff_out = self.feed_forward(x)
        x = self.norm3(x + ff_out)
        return x
```

---

### 训练细节

| 超参数 | 值 |
|--------|-----|
| 编码器/解码器层数 | 6 |
| 注意力头数 | 8 |
| 隐藏层维度 d_model | 512 |
| FFN 维度 | 2048 |
| Dropout | 0.1 |
| 优化器 | Adam (β₁=0.9, β₂=0.98) |
| 学习率 | warmup + 衰减 |

---

### 关键创新

1. **完全并行化**：摒弃 RNN，支持完整并行训练
2. **长距离依赖**：注意力直接连接任意位置，解决 RNN 梯度消失问题
3. **可扩展性**：后续 BERT、GPT 等均基于此架构

---

### 实验结果

在 WMT 翻译任务上：

- 英德翻译：BLEU **25.8**（超过所有现有模型）
- 英法翻译：BLEU **41.8**（单模型最优）

---

### 影响

Transformer 开启了 NLP 大模型时代，成为现代 LLM 的基石。后续 GPT、BERT、Claude 等均源于此。

---

### Transformer → LLM 进化之路

#### 发展脉络

```
Transformer (2017)
      │
      ├──► GPT (2018)        : 单向语言模型，12层，1.17亿参数
      │
      ├──► BERT (2018)       : 双向编码器，刷新NLP榜单
      │
      ├──► GPT-2 (2019)      : 15亿参数，开始涌现惊人能力
      │
      ├──► GPT-3 (2020)      : 1750亿参数，In-Context Learning
      │
      ├──► InstructGPT (2022) : RLHF对齐，成为ChatGPT基础
      │
      └──► GPT-4/Claude...   : 万亿参数，多模态，强推理
```

#### 核心跨越

| 跨越 | Transformer (2017) | LLM (2024) |
|------|------------------|------------|
| **规模** | 65M 参数 | 100B - 1T+ 参数 |
| **训练数据** | 36GB (WMT) | 数万亿 token |
| **预训练** | 需要标注数据 | 自监督大规模预训练 |
| **对齐** | 无 | RLHF/Constitutional AI |
| **推理能力** | 弱 | 思维链、工具调用、Agent |
| **多模态** | 纯文本 | 图像、音频、视频 |

#### 关键技术

**1. 预训练范式（下一个 token 预测）**

```
传统NLP: 任务驱动，数据标注
LLM预训练: 预测下一个token，无需标注，数据量万亿级
```

**2. 涌现能力（Emergence）**

模型规模突破临界点后，突然具备小模型没有的能力：

- 小模型：记不住"it"指代什么
- 大模型：自动学会指代消解、长程依赖

**3. 指令微调（Instruction Tuning）**

让模型遵循指令而非简单续写：

```
原始: "北京是中国的首都，南京是" → "中国的城市"
微调后: "北京是中国的首都。南京是哪里？" → "南京是中国的省会城市。"
```

**4. 对齐技术（Alignment）**

| 方法 | 说明 |
|------|------|
| **RLHF** | 人类反馈强化学习 |
| **Constitutional AI** | 准则驱动的对齐 |
| **DPO** | 直接偏好优化 |

**5. 推理激发**

| 技术 | 作用 |
|------|------|
| **CoT** | 鼓励模型输出推理步骤 |
| **Self-Consistency** | 多路径采样投票 |
| **ReAct** | 结合工具使用 |
| **R1** | 强化学习驱动的推理 |

#### LLM 的组成部分

```
LLM = Transformer 架构
    + 海量数据预训练（下一个token预测）
    + 指令微调（遵循指令）
    + 对齐技术（RLHF等）
    + 推理激发（CoT等）
    + 多模态融合（VL版本）
    + 工具调用（Function Calling）
    + ...
```

#### 一句话总结

| | Transformer | LLM |
|--|------------|-----|
| **定位** | 基础架构 | 完整系统 |
| **能力** | 序列建模 | 通用智能 |
| **核心差距** | 技术框架 | Scale + 对齐 + 涌现 |

**Transformer 是 LLM 的起点，但 LLM = Transformer + 大规模 + 对齐 + 涌现能力。**
