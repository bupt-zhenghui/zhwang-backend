---
draft: false
date: 2026-04-11
tags: [AI, agent, 推理]
categories: [AI]
---

**标题**: [Chain-of-Thought Prompting Elicits Reasoning in Large Language Models](https://arxiv.org/abs/2201.11903)

**来源**: NeurIPS 2022 | Google Brain

**作者**: Jason Wei, Xuezhi Wang, Dale Schuurmans, Maarten Bosma, Brian Ichter, Fei Xia, Ed Chi, Quoc Le, Denny Zhou

![image-20260412200559228](https://img-1300769438.cos.ap-beijing.myqcloud.com/images/image-20260412200559228.png)



<!-- more -->

### 核心问题

LLM 在大规模时表现出了惊人的能力，但在简单的算术、常识推理和符号操作等任务上仍然困难。标准 prompting（直接输入问题得到答案）效果有限。CoT 试图回答：**能否让 LLM 自己生成中间推理步骤来提升复杂任务表现？**

### 方法

**Chain-of-Thought Prompting**：在 prompt 中不仅给出问题-答案示例，还给出**中间推理步骤**（思维链）。

关键观察：
- 当 thought 链足够长时，模型能够自行推理出正确答案
- 不需要监督训练数据，仅通过 few-shot 示例即可激发推理能力
- 推理步骤本身就是模型输出的自然语言，无需额外标注

### 实验设置

| 任务类型 | 数据集 |
|---------|--------|
| 算术推理 | GSM8K, SVAMP, MAWPS, MathQA, AQuA |
| 常识推理 | StrategyQA, Date Understanding, Sports Understanding |
| 符号推理 | Last Letter, Coin Flip |

模型：PaLM、GPT-3、LaMDA 等多个尺度的 LLM

### 主要结果

- **算术推理**：CoT prompting 一致性提升效果，例如在 GSM8K 上 PaLM-540B 从 17.9% 提升到 **46.6%**
- **常识推理**：CoT 同样带来显著提升，尤其在需要多步推理的任务上
- **符号推理**：在小规模符号操作任务上同样有效
- **模型规模关键**：CoT 仅在足够大的模型（~100B 参数以上）上才显现出优势，较小的模型会产生不合逻辑的 thought 链

### 关键发现

1. **模型规模是前提**：CoT 的效果具有显著的模式临界性（emergent），小模型反而会被误导
2. **思维链质量决定效果**：合乎逻辑的推理步骤对结果至关重要
3. **与 self-consistency 互补**：结合采样投票机制（CoT-SC）可进一步大幅提升

Chain-of-Thought 是 LLM 推理能力研究的重要里程碑，证明了通过 prompting 即可激发模型的多步推理能力，为后续 ReAct 等工作奠定了基础。
