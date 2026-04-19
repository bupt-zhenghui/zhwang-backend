---
draft: false
date: 2026-04-19
tags: [AI, agent, 自我反思, Reflexion]
categories: [AI]
---

**标题**: [Reflexion: Language Agents with Verbal Reinforcement Learning](https://arxiv.org/abs/2303.11366)

**来源**: ArXiv 2023 | MIT & UC Berkeley

**作者**: Shinn, Labash, Gopinath (MIT CSAIL)

![image-20260419132742380](https://img-1300769438.cos.ap-beijing.myqcloud.com/images/image-20260419132742380.png)

<!-- more -->

### 核心问题

传统 Agent 在环境中犯错后，只能依赖外部信号（如 RL 的奖励模型）来调整行为。Reflexion 提出：**能否让 Agent 用语言反思错误，形成自我修正能力？**

### 核心思想

Reflexion = Agent + **语言化自我反思** + 记忆：

```
执行 → 观察结果 → 反思(生成语言反馈) → 决策修正
```

Agent 不再只是"做对/做错"，而是通过**口语化的反思**理解错误原因，并将这类经验存储到长期记忆中，下次遇到类似情况时主动避免。

### 框架三组件

| 组件 | 作用 |
|------|------|
| **Actor** | 基于当前状态选择动作 |
| **Evaluator** | 评估动作或轨迹的奖励/效果 |
| **Self-Reflection** | 生成语言反思，分析错误原因，更新记忆 |

### 与 ReAct 的区别

| | ReAct | Reflexion |
|---|---|---|
| **反馈来源** | 外部环境（Observation） | Agent 自己生成语言反思 |
| **记忆** | 无 | 有长期情景记忆 |
| **错误处理** | 遇错继续或重试 | 反思原因，主动规避 |
| **适用任务** | 知识密集型问答 | 需从失败中学习的任务 |

### 实验任务

| 任务 | 数据集 | 基线 | Reflexion |
|------|--------|------|-----------|
| 序列决策 | AlfWorld | 63% | **91%** |
| 多跳问答 | HotpotQA | 34% | **55%** |
| 验证任务 | TruthfulQA | 80% | **87%** |

### 关键发现

1. **语言反思比纯奖励信号更有效**：将错误"说出来"比只给数值奖励更能指导修正
2. **记忆是关键**：保存历史反思片段，Agent 能识别模式并主动规避
3. **少量经验即可学习**：仅几次失败就能形成有效的自我修正策略

Reflexion 证明了语言作为中间反馈形式的价值，为构建"会反思的 Agent"提供了新范式。
