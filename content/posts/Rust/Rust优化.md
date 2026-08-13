---
date: "2026-07-14T15:35:56+08:00"
title: "Rust优化"
categories:
    - Rust
tags:
---

以leetcode 3336为例

## 访问优化

整数加法 / 乘法 | 1 |
| 寄存器访问 | 0（已在流水线中） |
| L1 缓存 | ~4 |
| L2 缓存 | ~12 |
| L3 缓存 | ~40 |
| 主存 | ~200+

1.循环不变量外提

通过创建临时变量,把循环里的不变量提取出来,避免重复内存加载,让数据待在寄存器里，**零内存访问**。

2.消除冗余加载

```rust
// 改之前：f[row+j] 加载两次
g[col + j]     = mo(g[col + j]     + f[row + j]);  // 读 f
g[row + gv[j]] = mo(g[row + gv[j]] + f[row + j]);  // 又读 f

// 改之后：加载一次，复用
let v = f[row + j];       // 读 1 次，存寄存器
g[col + j]     = mo(g[col + j]     + v);
g[row + gv[j]] = mo(g[row + gv[j]] + v);
```

编译器**可能**优化掉重复加载（把 `v` 留在寄存器），但寄存器数量有限（x86-64 只有 16 个通用寄存器），压力大时会 spill 到栈上，反而更慢。手动提出来就是明确告诉编译器：这个值值得占一个寄存器。

3.热数据,减少缓存压力

在外面预处理的数据,可以放到循环里,缩小规模

4.批量操作替代逐元素循环

```rust
// 改之前：N² 次循环，每次 read f + read g + add + write g + bounds check ×4
for i in 0..N { for j in 0..N { g[i*N+j] = mo(g[i*N+j] + f[i*N+j]); } }

// 改之后：一次 memcpy，硬件用 256-bit SIMD 一次搬 8 个 i32
g.copy_from_slice(&f);
```

copy_from_slice`底层调用`memcpy`，CPU 用宽寄存器（128/256 bit）批量搬运，**一个周期处理 4-8 个元素**，比标量循环快一个数量级。
