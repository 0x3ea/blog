---
date: '2026-07-07T15:28:30+08:00'
title: 'Linux1'
categories:
  - Linux
tags:
---

# ABI

Application Binary Interface

二进制（机器码）层面的接口规范，确保不同的程序模块（如应用程序、库、操作系统）在编译后能够正确地协同工作

规范了以下部分:
1.调用约定 (Calling Convention)：规定函数调用的具体细节

  参数通过哪些寄存器传递，还是全部压入栈中。

  函数返回值如何获取。

  栈的布局和对齐方式（例如，x86-64 要求栈在函数调用前需 16 字节对齐）。

2.数据类型的大小、布局和对齐：规定了 int、long 等基本数据类型在内存中占用多少字节，以及结构体成员在内存中如何排列。

3.系统调用方式：规定了应用程序如何通过指令（如 syscall）向操作系统内核请求服务，以及系统调用号的定义。

4.目标文件（.o 文件）和可执行文件的格式：如 ELF（Executable and Linkable Format）格式，规定了二进制文件的结构，以便链接器和加载器能够正确解析。

abi会受架构和操作系统影响

linux+arm 和 linux+x86 就不是一套abi


# API

Application Programming Interface

组预先定义好的规则和协议，用于让不同的软件应用程序之间进行通信和交互。