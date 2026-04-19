---
draft: false
date: 2026-04-19
tags: [AI, agent, 论文汇总]
categories: [AI]
---

**标题**: LLM Agent 领域重要论文汇总

**说明**: 梳理 LLM Agent 方向的经典论文，按功能分类，持续更新。

<!-- more -->

## 1. 推理能力提升

| 论文 | 年份 | 会议/期刊 | 核心贡献 | 论文链接 |
|------|------|----------|----------|----------|
| **Chain-of-Thought (CoT)** | 2022 | NeurIPS 2022 | 引入思维链提示，引导模型逐步推理 | [arxiv](https://arxiv.org/abs/2201.11903) |
| **Self-Consistency** | 2023 | ICLR 2023 | 多路径采样+投票提升推理一致性 | [arxiv](https://arxiv.org/abs/2203.11171) |
| **Tree of Thoughts (ToT)** | 2023 | NeurIPS 2023 | 树状搜索探索多条推理路径 | [arxiv](https://arxiv.org/abs/2305.10601) |
| **Graph of Thoughts (GoT)** | 2023 | ArXiv | 图结构整合推理过程 | [arxiv](https://arxiv.org/abs/2308.09687) |

### 推理方法对比（CoT / Self-Consistency / ToT）

| 对比维度 | CoT | Self-Consistency | ToT |
|---------|-----|------------------|-----|
| **推理结构** | 单链顺序 | 多条独立平行链 | 树/图结构 |
| **回溯能力** | ❌ 无 | ❌ 无 | ✅ 有 |
| **中间评估** | ❌ 无 | ❌ 无 | ✅ 每步评估 |
| **答案选择** | 直接输出 | 投票取多数 | 搜索+评估 |
| **计算成本** | 低 | 中 | 高 |
| **核心思想** | 生成中间推理步骤 | 多路径采样+投票 | 显式树搜索+剪枝 |
| **适合场景** | 简单多步推理 | 路径等价的推理任务 | 需探索/战略决策的复杂问题 |
| **代表任务** | 算术、常识推理 | 数学、事实问答 | 24点游戏、创意写作 |
| **代表论文** | NeurIPS 2022 | ICLR 2023 | NeurIPS 2023 |

**对比总结**：

- **CoT**：基础款，引导模型生成中间推理步骤，单链路
- **Self-Consistency**：CoT + 多采样 + 投票，事后选择最优答案
- **ToT**：主动搜索树结构，边生成边评估边剪枝，适合复杂探索性任务

## 2. Agent 架构

| 论文 | 年份 | 会议/期刊 | 核心贡献 | 论文链接 |
|------|------|----------|----------|----------|
| **ReAct** | 2023 | ICLR 2023 | 协同推理与行动，动作空间扩展到工具调用 | [arxiv](https://arxiv.org/abs/2210.03629) |
| **Reflexion** | 2023 | ArXiv | 语言反馈自我反思 | [arxiv](https://arxiv.org/abs/2303.11366) |
| **Voyager** | 2023 | ArXiv | Minecraft 中持续学习的 agent | [arxiv](https://arxiv.org/abs/2305.16291) |
| **AutoGPT** | 2023 | 开源项目 | 自主任务分解与执行 | [github](https://github.com/Significant-Gravitas/AutoGPT) |

## 3. Tool Use / Tool Learning

| 论文 | 年份 | 会议/期刊 | 核心贡献 | 论文链接 |
|------|------|----------|----------|----------|
| **Toolformer** | 2023 | ArXiv | 模型自主学习调用外部工具 | [arxiv](https://arxiv.org/abs/2302.04761) |
| **ToolBench** | 2023 | ICML 2023 | 工具学习 Benchmark | [arxiv](https://arxiv.org/abs/2305.04091) |
| **WebGPT** | 2022 | NeurIPS 2022 | 浏览器交互的 GPT | [arxiv](https://arxiv.org/abs/2207.00222) |
| **WebAgent** | 2023 | ICML 2023 | 真实浏览器中执行任务 | [arxiv](https://arxiv.org/abs/2303.17580) |
| **RestGPT** | 2023 | IJCAI 2023 | RESTful API 编排 | [arxiv](https://arxiv.org/abs/2306.08104) |

## 4. Memory / Knowledge

| 论文 | 年份 | 会议/期刊 | 核心贡献 | 论文链接 |
|------|------|----------|----------|----------|
| **MemGPT** | 2023 | MLSys 2023 | 层级记忆管理 | [arxiv](https://arxiv.org/abs/2310.08560) |
| **RAG** | 2023 | ArXiv | 检索增强生成（综合技术，非单一论文） | [arxiv](https://arxiv.org/abs/2005.11401) |

## 5. Multi-Agent

| 论文 | 年份 | 会议/期刊 | 核心贡献 | 论文链接 |
|------|------|----------|----------|----------|
| **CAMEL** | 2023 | ArXiv | 多 agent 对话协作框架 | [arxiv](https://arxiv.org/abs/2303.17760) |
| **MetaGPT** | 2023 | ArXiv | 软件开发多 agent | [arxiv](https://arxiv.org/abs/2308.00352) |

## 6. Planning / Reasoning

| 论文 | 年份 | 会议/期刊 | 核心贡献 | 论文链接 |
|------|------|----------|----------|----------|
| **HuggingGPT** | 2023 | NeurIPS 2023 | LLM 作为规划器连接 ML 模型 | [arxiv](https://arxiv.org/abs/2303.17580) |
| **PAL** | 2023 | NeurIPS 2022 | Program-Aided Reasoning | [arxiv](https://arxiv.org/abs/2211.10435) |

## 7. Evaluation / Benchmark

| 论文 | 年份 | 会议/期刊 | 核心贡献 | 论文链接 |
|------|------|----------|----------|----------|
| **AgentBench** | 2023 | ArXiv | Agent 能力 Benchmark | [arxiv](https://arxiv.org/abs/2308.03688) |
| **WebArena** | 2023 | NeurIPS 2023 | 真实 Web 任务评估 | [arxiv](https://arxiv.org/abs/2307.13854) |

---

## 论文解读

详细解读已单独成文：

- [Chain-of-Thought](CoT.md)
- [ReAct](ReAct.md)
- [Self-Consistency](Self-Consistency.md)
- [Toolformer](Toolformer.md)
