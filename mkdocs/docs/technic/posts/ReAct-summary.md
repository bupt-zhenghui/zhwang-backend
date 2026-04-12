---
draft: false
date: 2026-04-11
tags: [AI, agent]
categories: [AI]
---

**标题**: [REACT: Synergizing Reasoning and Acting in Language Models](https://arxiv.org/abs/2210.03629)

**来源**: ICLR 2023 | Princeton University & Google Research

**作者**: Shunyu Yao, Jeffrey Zhao, Dian Yu, Nan Du, Izhak Shafran, Karthik Narasimhan, Yuan Cao

<!-- more -->

### 核心问题

大语言模型（LLM）的推理能力（如 Chain-of-Thought）和行动能力（如生成动作计划）长期以来被分开研究。ReAct 探索将两者**交错结合**，使推理帮助诱导、跟踪和更新动作计划，动作则负责从外部来源（知识库、环境）获取信息。

### 方法

**ReAct** 核心思想：在推理轨迹（Thought）和动作（Action）之间形成闭环——

- **Thought**：让模型进行推理思考（"我现在需要找...，应该搜索..."）
- **Action**：调用外部工具（如 Wikipedia API、网页搜索）
- **Observation**：获取返回结果，反馈给模型继续推理

形成 `Thought → Action → Observation → Thought → ...` 的交替序列。

### 实验任务

| 任务 | 数据集 | 环境 |
|------|--------|------|
| 多跳问答 | HotpotQA | Wikipedia API |
| 事实核查 | FEVER | Wikipedia API |
| 文本游戏 | ALFWorld | 模拟家庭环境 |
| 网页导航 | WebShop | 真实网购环境 |

### 主要结果

- **HotpotQA / FEVER**：ReAct 有效克服了 CoT 的幻觉问题，ReAct+CoT-SC 组合达到最佳（34.2% / 64.6%）
- **ALFWorld**：ReAct 成功率 71%，超过 Act (45%) 和 BUTLER (37%) **34%**
- **WebShop**：ReAct 成功率 40%，超过 IL+RL 方法 **10%**
- ReAct 生成的人类可读的任务解决轨迹，显著提升可解释性和可信度

### 关键发现

1. **幻觉问题**：CoT 幻觉率 14%，ReAct 仅 6%——外部知识检索显著减少幻觉
2. **推理与动作缺一不可**：纯推理缺乏事实 grounding，纯动作无法分解子目标
3. **稀疏推理有效**：决策任务中稀疏的 Thought 优于无 Thought 的 Act-only
4. **few-shot 即可生效**：仅需 1-2 个示例就能超越大量微调的模仿/强化学习方法

### 总结

ReAct 证明了将 LLM 的推理能力与外部交互能力结合的巨大潜力，为构建更可靠、可解释的 LLM Agent 奠定了基础。
