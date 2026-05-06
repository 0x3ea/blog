---
date: '2026-04-30T15:44:33+08:00'
title: 'Shell'
categories:
    - Linux
tags:
    - Shell
---

起因是想给 [KeyForge](https://github.com/0x3ea/KeyForge) 加一个自动安装功能,gpt 给我写了一个 install.sh ,顺便也学习一下shell 脚本.

# 什么是Shell



下面是一些常见的shell

```
Shell / 命令解释器
├── Unix 风格
│   ├── sh        # 最基础、最通用，适合写安装脚本
│   ├── bash      # Linux 常见，比 sh 强
│   ├── zsh       # macOS 默认，交互体验好
│   └── fish      # 另一个现代 shell，语法不兼容 sh
│
└── Windows 原生
    ├── cmd.exe      # 老式 Windows 命令行
    └── PowerShell   # 现代 Windows shell，语法完全不同
```