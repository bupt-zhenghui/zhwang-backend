---
draft: false
date: 2025-12-21
tags: [算法, 数据结构, 缓存]
categories: [algorithm]
---

# LRU缓存

LRU (Least Recently Used Cache) 缓存，即最近最少使用缓存，是一种基于页面置换算法的缓存淘汰策略，核心思想是：当缓存空间满时，优先淘汰最近最少被访问的数据，为新数据腾出空间。

LRU 缓存的设计遵循一个假设：最近被访问的数据，未来被访问的概率更高；反之，最近最少被访问的数据，未来被访问的概率更低。

实现LRU缓存的核心是在时间复杂度O(1)的前提下实现`get`和`put`方法，对应Leetcode第 [146](https://leetcode.cn/problems/lru-cache/) 题：

```python
class LRUCache:

    def __init__(self, capacity: int):

    def get(self, key: int) -> int:
        """
        Fetch data from cache with O(1) Time Complexity
        """

    def put(self, key: int, value: int) -> None:
        """
        Update data from cache with O(1) Time Complexity
        """
```

<!-- more -->

