---
draft: false
date: 2026-04-19
tags: [AI, agent, 工具调用]
categories: [AI]
---

**标题**: [Toolformer: Language Models Can Teach Themselves to Use Tools](https://arxiv.org/abs/2302.04761)

**来源**: arXiv 2023 | Meta AI

**作者**: Noah Shazeer, Vimal Thakral, Noam Brown, et al.

![image-20260419113251509](https://img-1300769438.cos.ap-beijing.myqcloud.com/images/image-20260419113251509.png)

<!-- more -->

### 核心问题

大语言模型（LLM）虽然具备强大的推理能力，但无法访问实时信息、无法执行计算、无法使用外部工具。Toolformer 探索：**能否让 LLM 自监督学习调用外部工具，而不依赖人工标注？**

### 核心思想

Toolformer 让 LLM 通过**自监督学习**的方式学会使用工具，核心思想是：

1. **API 调用作为特殊 Token**：将工具调用转化为序列中的特殊 token
2. **自监督训练**：通过 API 响应作为伪标签，让模型学习何时调用工具
3. **权衡机制**：模型学会判断何时需要工具、何时可以独立回答

### 支持的工具

| 工具 | 功能 | 用途 |
|------|------|------|
| Calculator | 数学计算 | 避免 LLM 的数值计算错误 |
| Wikipedia Search | 知识检索 | 获取实时/最新信息 |
| Machine Translation | 翻译 | 跨语言处理 |
| Calendar | 日历 | 时间相关查询 |
| Python REPL | 代码执行 | 动态计算与验证 |

### 方法

**三阶段流程**：

```
阶段1：工具采样
  → 对每个工具生成大量 API 调用候选
  → 筛选有效调用（返回有帮助的结果）

阶段2：过滤
  → 只保留能改善模型响应的调用
  → 去除无关或冗余的调用

阶段3：微调
  → 使用筛选后的数据微调 LLM
  → 学习何时调用、调用什么、如何使用结果
```

### 实例

**问题**：法国的首都是什么？最近获得诺贝尔物理奖的科学家是谁？

**无工具 LLM**：
```
可能产生过时信息或幻觉
```

**Toolformer**：
```
Thought：我不确定最新诺贝尔奖信息，需要搜索
Action：Search[最近诺贝尔物理奖得主]
Observation：2023年诺贝尔物理奖授予了 Pierre Agostini, Ferenc Krausz, Anne L'Huillier
Answer：法国的首都是巴黎。2023年诺贝尔物理奖授予了 Pierre Agostini, Ferenc Krausz, Anne L'Huillier
```

### 实验结果

- **计算任务**：Calculator 显著减少 LLM 的数值计算错误
- **问答任务**：Wikipedia Search 提升实时问答准确性
- **低资源语言**：翻译工具提升多语言处理能力
- **零样本泛化**：微调后的模型可泛化到未见过的工具使用场景

### 关键发现

1. **自监督可行**：无需人工标注，模型自己能学会工具调用
2. **工具选择有策略**：模型学会判断何时需要工具、何时直接回答更高效
3. **质量 > 数量**：精心筛选的高质量 API 调用数据比大量低质量数据更有效
4. **最小化干扰**：过度工具调用反而降低性能，平衡至关重要

### 总结

Toolformer 证明了 LLM 可以通过自监督方式学会使用工具，为构建更智能的 Agent 奠定了基础。其思想影响了后续的 Tool Learning 研究方向。
