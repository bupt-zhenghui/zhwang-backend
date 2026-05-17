---
draft: false
date: 2026-04-26
tags: [AI, MoE, LLM, DeepSeek]
categories: [AI]
---

# DeepSeek 系列论文汇总

<!-- more -->

---

## DeepSeek-V4 (2025)

**论文**: DeepSeek-V4: Towards Highly Efficient Million-Token Context Intelligence

### 核心贡献

DeepSeek-V4 是 DeepSeek 系列新一代 MoE 大模型，专注于**百万 token 上下文**的高效处理，提出三项关键创新：

1. **混合注意力架构 (CSA + HCA)**：显著降低长上下文推理成本
2. **Manifold-Constrained Hyper-Connections (mHC)**：增强残差连接稳定性
3. **Muon 优化器**：更快的收敛速度和训练稳定性

---

### 模型规格

| 模型 | 总参数量 | 激活参数 | 上下文长度 |
|------|---------|---------|-----------|
| DeepSeek-V4-Pro | 1.6T | 49B | 1M tokens |
| DeepSeek-V4-Flash | 284B | 13B | 1M tokens |

---

### 核心创新

#### 1. 混合注意力 (CSA + HCA)

**设计背景**：标准注意力机制在超长上下文场景下面临**二次方计算复杂度**瓶颈。

**CSA (Compressed Sparse Attention)**：
- 将每 $m$ 个 token 的 KV 压缩为 1 个条目
- 结合 DeepSeek Sparse Attention (DSA) 稀疏选择
- 压缩率 $m=4$，选择 top-k=512/1024 压缩 KV 条目

**HCA (Heavily Compressed Attention)**：
- 更激进的压缩，每 $m'$ 个 token 的 KV 压缩为 1 个条目
- 压缩率 $m'=128$，但保持密集注意力

**效率提升**（1M token 上下文下 vs DeepSeek-V3.2）：

| 指标 | DeepSeek-V4-Pro | DeepSeek-V4-Flash |
|------|----------------|-------------------|
| 推理 FLOPs | 27% | 10% |
| KV Cache | 10% | 7% |

#### 2. mHC (Manifold-Constrained Hyper-Connections)

**问题**：标准 Hyper-Connections 在深层堆叠时容易出现**数值不稳定**。

**解决方案**：将残差映射矩阵 $B_l$ 约束到**双随机矩阵流形**（Birkhoff 多面体）：

$$
B_l \in \mathcal{M} \coloneqq \{M \in \mathbb{R}^{n \times n} \mid M\mathbf{1}_n = \mathbf{1}_n, \mathbf{1}_n^T M = \mathbf{1}_n^T, M \geq 0\}
$$

**效果**：
- 确保映射矩阵的谱范数 $\|B_l\|_2 \leq 1$，残差变换非扩展
- 通过 Sinkhorn-Knopp 算法投影（$t_{max}=20$ 次迭代）
- 增强跨层信号传播的稳定性

#### 3. Muon 优化器

基于 **Newton-Schulz 正交化**的优化器：

- 保持 AdamW 用于 embedding、prediction head、静态偏置
- 其他模块使用 Muon
- 采用混合 Newton-Schulz 迭代：前 8 步快速收敛，后 2 步精确稳定

---

### 基础设施创新

| 技术 | 说明 |
|------|------|
| **细粒度 EP 调度** | 专家波次化，减少通信等待 |
| **TileLang DSL** | 平衡开发效率与运行时性能 |
| **Batch-Invariant 内核** | 确保训练与推理的位级一致性 |
| **FP4 量化** | MoE 专家权重和索引器 QK 路径使用 FP4 |
| **On-Disk KV Cache** | 共享前缀请求的 KV 缓存复用 |

---

### 预训练

- **数据量**：32T tokens
- **数据构成**：数学、代码、网页、长文档、多语言等
- **策略**：样本级注意力掩码、文档打包、最小化截断

---

### 后训练：两阶段范式

1. **专家独立训练**：在数学、代码、Agent、指令遵循等目标领域独立训练
2. **统一蒸馏**：通过 On-Policy Distillation (OPD) 整合多个专家能力

---

## DeepSeek-V3 (2024)

DeepSeek-V3 在 V2 基础上进一步优化：

- 采用 **Multi-Token Prediction (MTP)** 预测多个 token
- 继续使用 MLA 和 DeepSeekMoE
- 训练数据扩展至 14.8T tokens
- 进一步降低训练成本

---

## DeepSeek-V2 (2024)

**论文**: DeepSeek-V2: A Strong, Economical, and Efficient Mixture-of-Experts Language Model

### 核心贡献

DeepSeek-V2 提出了两个核心技术：

1. **Multi-head Latent Attention (MLA)**：降低推理时的 Key-Value 缓存开销
2. **DeepSeekMoE**：改进的 MoE 架构，支持更高效的稀疏计算

---

### 1. Multi-head Latent Attention (MLA)

#### 问题

标准 Multi-Head Attention (MHA) 在推理时需要缓存大量 Key-Value：

- 每个注意力头都需要缓存 K 和 V
- 对于长上下文，KV Cache 成为瓶颈

#### 解决方案

MLA 通过低秩投影压缩 KV：

$$
c^{KV} = W^{DKV}h_t
$$

$$
k^{MLA}_t = W^{UK}c^{KV}
$$

$$
v^{MLA}_t = W^{UV}c^{KV}
$$

其中 $c^{KV}$ 是压缩后的潜在向量，远小于原始的 K 和 V。

#### 优势

| 对比 | MHA | MLA |
|------|-----|-----|
| KV 缓存 | 很大 | 大幅降低 |
| 推理内存 | 高 | 低 |

---

### 2. DeepSeekMoE

#### 核心思想

将专家分割为更细粒度，并引入共享专家：

$$
h_t' = h_t + \sum_{i=1}^{N_s} \text{FFN}_i^{(s)}(h_t) + \text{topk}\left(\sum_{j=1}^{N_r} \text{FFN}_j^{(r)}(h_t)\right)
$$

#### 关键设计

**1. 细粒度专家分割**

- 将专家拆分为更小的子专家
- 提高专家的专业化程度
- 允许更灵活的路由

**2. 共享专家**

- 部分专家始终激活（共享知识）
- 减少路由选择的信息损失

**3. 节点级负载均衡**

- 辅助损失促进专家在节点间均匀分布
- 避免单节点过载

---

### 架构对比

| 维度 | DeepSeek-V1 | DeepSeek-V2 |
|------|------------|-------------|
| **总参数** | 236B | 236B |
| **激活参数** | 21B | 21B |
| **注意力** | MHA | MLA |
| **MoE** | 标准 | DeepSeekMoE |
| **KV 缓存** | 大 | 大幅减少 |
| **训练效率** | - | 提升 42% |

---

### 创新点总结

1. **MLA**：通过低秩投影减少推理时 KV 缓存，显著降低内存占用
2. **DeepSeekMoE**：细粒度专家 + 共享专家，提高专家利用率
3. **节点级负载均衡**：辅助损失确保专家均匀分布
4. **训练效率**：综合优化提升训练效率 42%

---

## 技术演进路线

| 版本 | 核心创新 | 关键突破 |
|------|---------|---------|
| **V4** | CSA/HCA + mHC + Muon | 1M token 高效上下文，10x 效率提升 |
| **V3** | MTP + 14.8T 预训练 | 多 token 预测，更大规模 |
| **V2** | MLA + DeepSeekMoE | 低秩 KV 压缩，42% 训练效率提升 |

---

## 一句话总结

DeepSeek 系列通过 **混合压缩注意力 → MTP → MLA** 的技术演进，持续降低大模型训练和推理成本，为开源 LLM 提供高效可行的技术路线。
