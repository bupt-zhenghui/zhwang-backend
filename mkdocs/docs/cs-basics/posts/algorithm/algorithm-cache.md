---
draft: false
date: 2025-12-21
tags: [算法, 数据结构, 缓存]
categories: [algorithm]
---

## 1. LRU缓存

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

!!! tip "核心思路"
    - 考虑通过哈希表+双向链表实现LRU缓存<br>
    - 双向链表的头部为最近使用的节点，依次向后排列，尾部即为最近最少使用的节点<br> 
    - 哈希表的key为要存储的kv键值对的key，value为对应的双向链表中的节点<br>
    - 在get操作时，如果存在对应节点，则将该节点移到链表头部，并返回对应value<br>
    - 在put操作时，如果存在对应节点，则将该节点移到链表头部，并更新对应value；如果不存在对应节点，则新增节点置于链表头部；如果已达到缓存最大容量，则删除末尾节点



```python
class DLinkedNode:
    def __init__(self, key, value):
        self.key = key
        self.value = value
        self.next = None
        self.prev = None

class LRUCache:

    def __init__(self, capacity: int):
        self.capacity = capacity
        self.cache = dict()
        node = DLinkedNode(-1, -1)
        node.next = node
        node.prev = node
        self.dummy = node

    def get(self, key: int) -> int:
        if key not in self.cache:
            return -1
        self._move_to_head(self.cache[key])
        # self._monitor()
        return self.cache[key].value

    def put(self, key: int, value: int) -> None:
        if key in self.cache:
            node = self.cache[key]
            node.value = value
            self._move_to_head(node)
            # self._monitor()
            return
        if len(self.cache) == self.capacity:
            self._remove_tail()
        node = DLinkedNode(key, value)
        self._add_to_head(node)
        self.cache[key] = node
        # self._monitor()

    def _move_to_head(self, node):
        node.prev.next = node.next
        node.next.prev = node.prev
        node.next = self.dummy.next
        self.dummy.next.prev = node
        node.prev = self.dummy
        self.dummy.next = node
    
    def _add_to_head(self, node):
        node.next = self.dummy.next
        node.prev = self.dummy
        self.dummy.next.prev = node
        self.dummy.next = node
    
    def _remove_tail(self):
        tail = self.dummy.prev
        self.dummy.prev = tail.prev
        tail.prev.next = self.dummy
        self.cache.pop(tail.key)

    def _monitor(self):
        node = self.dummy.next
        while node != self.dummy:
            print(node.key, end=', ')
            node = node.next
        print()
```


## 2. LFU缓存

LFU 缓存（Least Frequently Used Cache）同样是一种缓存淘汰策略，其核心思想是：当缓存空间满时，优先淘汰访问频率最低的缓存数据。

它与常见的 LRU（最近最少使用）缓存的核心区别在于：

- LRU 依据访问时间淘汰数据（淘汰最久未被访问的）
- LFU 依据访问频率淘汰数据（淘汰被访问次数最少的）

实现LFU缓存的核心是在时间复杂度O(1)的前提下实现`get`和`put`方法，对应Leetcode第 [460](https://leetcode.cn/problems/lfu-cache/description/) 题

![image-20251226224957054](https://img-1300769438.cos.ap-beijing.myqcloud.com/images/image-20251226224957054.png)

!!! tip "核心思路"
    - LRU缓存只需要通过双向链表按最后一次访问时间对元素进行排序即可，而LFU缓存是优先淘汰访问频率低的元素，如果访问频率相同，则淘汰最久没有访问的元素<br>
    - 这意味着在LRU缓存基础上还要考虑每个元素的访问频率<br>
    - 可以类比为读若干本书的场景，某一本书第一次读，则将该书放入“看过1次”的链表，如果再读一次，则将它取出，放入“看过两次”的链表，以此类推......<br>
    - 在get操作时，仍维护一个哈希表，其中包含了所有链表中的元素；如果get到了元素，则将该元素从当前链表取出，放入下一个链表的头部，表示频率+1，且为同频率下最近访问的元素<br>
    - 在put操作时，如果存在对应节点，则修改该节点value，并将该节点移到下一个链表的头部；如果不存在对应节点，则新增节点到第一个链表的头部；如果超出了缓存的容量，则需要从第一个链表中移除末尾节点，这里如果第一个链表为空，则需要往后续链表取出元素（这里如果要保证O(1)的时间复杂度，就需要一个额外的指针指向最近的存在元素的链表，需要在get和put操作后额外判断一次当前指针对应的链表是否为空，如果为空，就指到下一链表；如果put一个新元素，就将该指针指回第一个链表）



```python
class LFUCache:

    def __init__(self, capacity: int):
        self.capacity = capacity
        self.freq = 0  # 指向最近的存在元素的链表
        self.cache = dict()

        dummy = DLinkedNode()
        dummy.next = dummy
        dummy.prev = dummy
        self.node_list = [dummy]  # 构建一个链表列表，第一个链表放置访问频率为1的元素，访问频率提高则将元素移入后方的链表

    def get(self, key: int) -> int:

    def put(self, key: int, value: int) -> None:

```















