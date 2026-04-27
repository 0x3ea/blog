---
date: '2026-04-15T14:35:33+08:00'
title: 'Go-项目规范'
categories:
tags:
    - GO
---

# 初始化项目

`go mod init github.com/0x3ea/KeyForge`

带上前缀的作用:

1. 模块唯一标识

防止命名冲突

2. 自动下载依赖

```shell
# Go 会从 github.com 自动拉取代码
go get github.com/0x3ea/KeyForge
```
3. 版本管理
```shell
import "github.com/gin-gonic/gin/v2"  // 带版本号
```
# 引用函数

```go
"github.com/0x3ea/KeyForge/internal/crypto"
key := crypto.GenerateKey([]byte("123456"))
```


# 构建项目

```bash
go build -o Keyforge
```

# 工具

gofmt

```shell
# 显示当前文件与格式化后版本的差异对比（diff），但不修改原文件。
gofmt -d 文件名.go
```

| 命令               | 行为                  |
| ---------------- | ------------------- |
| `gofmt -w 文件.go` | **直接覆盖**写入格式化后的内容   |
| `gofmt -l 文件.go` | 只**列出**需要格式化的文件名    |
| `gofmt -d 文件.go` | **打印 diff**，不修改文件   |
| `gofmt 文件.go`    | 打印格式化后的完整内容到 stdout |


