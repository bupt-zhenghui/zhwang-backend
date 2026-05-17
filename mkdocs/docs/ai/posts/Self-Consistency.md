---
draft: false
date: 2026-04-19
tags: [AI, agent, 推理]
categories: [AI]
---

**标题**: [Self-Consistency Improves CoT Reasoning in Language Models](https://arxiv.org/abs/2203.11171)

**来源**: ICLR 2023 | Google Brain

**作者**: Xuezhi Wang, Jason Wei, Dale Schuurmans, Quoc Le, Maarten Bosma, Brian Ichter, Fei Xia, Ed Chi

![image-20260419111101728](https://img-1300769438.cos.ap-beijing.myqcloud.com/images/image-20260419111101728.png)

<!-- more -->

### 核心问题

Chain-of-Thought (CoT) 通过单路径贪婪解码生成推理链，但存在**幻觉风险**——一步推理错误则全程错误。Self-Consistency 试图回答：**能否利用多条推理路径的一致性来过滤错误答案？**

### 核心思想

对于同一个问题，正确的推理路径虽然可能不同，但最终答案应该**趋向一致**。

**Self-Consistency 是一种无需额外训练的解码策略**，核心是**多次采样 + 多数投票**：

1. **多次采样**：使用 CoT prompting，让 LLM 生成多条不同的推理路径（temperature > 0）
2. **多数投票**：统计各答案的出现频率，选择最常见的作为最终答案

```
问题 → [采样推理路径1 → 答案A]
     → [采样推理路径2 → 答案B]
     → [采样推理路径3 → 答案A]

最终答案 = A（出现2次，票数最高）
```

### 方法对比

| 对比维度 | CoT | Self-Consistency |
|---------|-----|------------------|
| 路径数量 | 1 条 | 多条（N 条） |
| 解码方式 | greedy（贪婪） | 多样采样（temperature > 0） |
| 错误容忍 | 无，一条错全错 | 有，少数错误被多数票覆盖 |
| 计算成本 | 1x | N x |

### 实例说明

**问题**：小明有 23 颗糖，给了小红 8 颗，又从爸爸那里得到 15 颗。请问小明现在有多少颗糖？

**CoT（单路径）**：
```
推理：23 - 8 = 15，15 + 15 = 30
最终答案：30（无论对错都接受）
```

**Self-Consistency（多路径 + 投票）**：
```
路径1：23 - 8 = 15，15 + 15 = 30  →  答案：30 ✓
路径2：23 + 15 = 38，38 - 8 = 30  →  答案：30 ✓
路径3：23 - 8 = 16（算错），16 + 15 = 31  →  答案：31 ✗

投票结果：30 出现 2 次，31 出现 1 次
最终答案：30
```

> CoT 像一个人做题无人校验；Self-Consistency 像班级多人分别做题，最后举手表决。

### 实验设置

| 任务类型 | 数据集 |
|---------|--------|
| 算术推理 | GSM8K, SVAMP, AQuA, MATH |
| 常识推理 | StrategyQA, Date Understanding |
| 符号推理 | Last Letter, Coin Flip |

模型：PaLM-540B, GPT-3, LaMDA 等

### 主要结果

- **算术推理**：PaLM-540B 在 GSM8K 上从 73% 提升到 **83.4%**
- **与 CoT 互补**：在 CoT 基础上进一步大幅提升
- **模型规模正相关**：模型越大，Self-Consistency 收益越高
- **无需额外训练**：仅改变解码策略

### 关键发现

1. **正确答案具有一致性**：正确的推理逻辑更"紧凑"，更容易收敛到相同答案；错误的推理更容易发散
2. **简单任务收益低**：对于可直接得出答案的问题，多路径采样开销不划算
3. **计算成本换质量**：延迟是单路径的 N 倍，但换取更可靠的答案

Self-Consistency 通过"多数投票"机制，利用多条推理路径的一致性来过滤幻觉答案，是 CoT 的重要增强方法。其简单高效的思想启发了后续大量推理加速和优化工作。
