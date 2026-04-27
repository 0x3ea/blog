---
title: Go-基本语法
date: '2026-03-30'
categories:
  - Example
tags:
  - Go
---

# 基本类型

| 类型               | 传值方式     | 能修改原数据?             |
| ------------------ | ------------ | ------------------------- |
| int, float, string | 拷贝值       | 需要传指针                |
| array              | 拷贝整个数组 | 需要传指针                |
| struct             | 拷贝结构体   | 需要传指针                |
| pointer            | 拷贝地址     | 通过指针修改              |
| slice              | 拷贝头部     | 可修改元素，append 不影响 |
| map                | 拷贝指针     | 可以                      |
| channel            | 拷贝引用     | 可以                      |

为什么 `slice` 的 `append` 不影响?

`slice` 包括三部分:指针,长度,容量

传参时拷贝了这三部分，函数内 `append` 不会影响这三部分

```go
func f(p []int) {
	p = append(p, 1)
}

func main() {
	var q = []int{1, 2, 3}
	f(q)
	fmt.Println(len(q))
	fmt.Println(cap(q))
}
```

# 包(package)

```shell
import (
	"github.com/0x3ea/KeyForge/internal/crypto"
	"github.com/0x3ea/KeyForge/internal/encode"
)
```
导入包时,实际上导入的是包的物理位置
调用时,实际上调用的是 .go 文件里的 package 声明


# 导出规则

Go 中所有标识符（变量、常量、函数、类型、方法）的可见性规则：

| 首字母 | 可见性       | 示例      |
| ------ | ------------ | --------- |
| 大写   | 公开（导出） | IssuesURL |
| 小写   | 私有（未导出）| issuesURL |

