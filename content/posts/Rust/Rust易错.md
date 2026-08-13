---
date: "2026-07-20T13:59:23+08:00"
title: "Rust易错"
categories:
    - Rust
tags:
---

# 借用

对于这样一个数组 `mut grid: Vec<Vec<i32>>`

我想交换(i,j) (i,j+1)

于是写了grid[i].swap(j, j - 1);

但是交换(i,j) (i+1,j)呢?

我写了`swap(&mut grid[i][0], &mut grid[i - 1][0]);`

```
error[E0499]: cannot borrow `grid` as mutable more than once at a time
   --> src/lib.rs:127:44
    |
127 |                 swap(&mut grid[i][0], &mut grid[i - 1][0]);
    |                 ----      ----             ^^^^ second mutable borrow occurs here
    |                 |         |
    |                 |         first mutable borrow occurs here
    |                 first borrow later used by call
    |
    = help: use `.split_at_mut(position)` to obtain two mutable non-overlapping sub-slices
```

看起来是重复借用grid导致的错误,但是我写的明明是&mut grid[i][0], &mut grid[i - 1][0] ,不应该是grid[i][0],grid[i-1][0]的借用吗?

rust的借用过程

```
要 &mut grid[i][0]
  → 第 1 步:对 grid 做 IndexMut(即 grid[i]),需要 &mut grid  ← 借用的是外层 grid!
  → 第 2 步:对 grid[i] 做 IndexMut(即 [0]),需要 &mut grid[i]
  → 得到 &mut grid[i][0]
```

所以 `&mut grid[i][0]` 和 `&mut grid[i-1][0]` **都从 `grid` 开始借**,虽然最终指向不同行不同列,但**借用链的起点是同一个 `grid`**。两个 `&mut grid` 同时存在 → 报错说的就是 `grid`

为什么是 `grid` 而不是 `grid[i]`?

因为 `grid[i]` 本身**不是一个独立的变量/对象**,它是 `grid` 通过 `IndexMut` **临时算出来的引用目标**。借用检查器只认**具名变量**,而 `grid` 是变量,`grid[i]` 不是(它是个表达式)。

所以无论你嵌套几层索引(`grid[i]`、`grid[i][j]`、`grid[i][j][k]`…),借用检查器追溯到**最外层的具名变量 `grid`**,在那里做冲突判断。报错自然指向 `grid`

grid[i].swap(j, j-1)` 能过**:整条表达式中,`grid[i]`只求值一次,即`&mut grid`只借一次(给`grid[i]`),`.swap()`在这个`&mut grid[i]`内部完成交换。**整个调用链里`&mut grid` 只出现一次\*\*,不冲突。

**`split_at_mut` 能过**:它签名是 `fn split_at_mut(&mut self, mid) -> (&mut [T], &mut [T])`——**只借 `&mut grid` 一次**,内部用 `unsafe` 切出两段不重叠的切片返回。返回的两个切片类型上是两个独立引用,但它们**共享同一次对 `grid` 的借用**(通过 unsafe 证明 disjoint)。检查器只看到一次 `&mut grid`,通过。

**临时变量三段式能过**:每条语句单独借用,先后不重叠。
