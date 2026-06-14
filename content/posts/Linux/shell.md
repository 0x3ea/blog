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

# shell script

shell 脚本里，函数里赋值的变量默认是全局变量

```shell
#!/user/bin/env sh
```
`/usr/bin/env` 是一个可执行程序，sh是传入的参数，env 会根据当前环境变量 PATH 去查找名为 sh 的可执行文件

## command -v

检查某个命令是否可用，以及它实际对应的路径或别名，如果命令不存在，返回1
```shell
command -v env # /usr/bin/env
command -v 1345634 # 1
```

比如这个函数:
```shell
if ! command -v "$1" >/dev/null 2>&1; then
        echo "error: required command not found: $1" >&2
        exit 1
    fi
```

`command -v "$1" >/dev/null`：把`command -v "$1"`的输出重定向到/dev/null

`2>&1`:把标准错误（文件描述符 2）重定向到标准输出（文件描述符 1）当前指向的地方(/dev/null)

整个command -v "$1" >/dev/null 2>&1 只剩下返回码，根据返回码判断命令是否存在

# uname

uname -s:操作系统类型(Linux/Darwin)

uname -m:CPU 架构(x86_64/arm64/aarch64)

# test

检查一个文件是否存在且是普通文件（不是目录、设备文件等）

用 test 命令

```shell
if test ! -f "/path/file"; then
    echo "不存在"
fi
```

用 [ ]，最后必须跟 ]
```shell
if [ ! -f "/path/file" ]; then
    echo "不存在"
fi
```
! 是 test 命令自己的逻辑非运算符，用来把后面的条件判断结果反转

# install

复制文件，同时设置目标文件的属性（如权限、所有者），并能创建目标目录

install ≈ cp + chown + chmod + mkdir -p