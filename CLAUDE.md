# 项目说明

## 定期任务

### 每周周总结（每周日）

每逢周日，需提醒用户对本周生活做总结记录，保存到 blog 目录。

**文件路径**：`mkdocs/docs/blog/posts/2026-weekxx-summary.md`

**命名格式**：`2026-weekxx-summary.md`（xx为当年第几周，如2026-04-12为第15周，记作week15）

**Frontmatter**：
```
---
draft: false
date: YYYY-MM-DD
tags: [周总结]
categories: [生活]
---
```

**内容格式**：使用 HTML 表格记录，分三列

```
## YYYY-MM-DD ~ YYYY-MM-DD
<table>
  <tr><th>范畴</th><th>内容</th><th>备注</th></tr>
  <tr><td>学习</td><td>...</td><td>...</td></tr>
  <tr><td>运动</td><td>...</td><td>...</td></tr>
  <tr><td>阅读</td><td>...</td><td>...</td></tr>
</table>
```

**范畴可选**：学习 / 运动 / 阅读 / 其它（其它如无内容则不体现）
- 论文速览只占一行，多篇论文在备注中用 `<br>` 分行
