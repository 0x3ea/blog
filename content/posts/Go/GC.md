---
date: '2026-05-18T13:40:42+08:00'
title: 'GC'
categories:
  - Go
tags:
---

GC 不可控

Go 运行时管理内存。
slice 可能扩容复制。
string 不可变且不能清零。
GC 什么时候回收不可控。
编译器/库可能产生副本

string(passwordBytes) 会复制。
fmt.Println、JSON、clipboard API 可能复制。
term.ReadPassword 返回的 []byte 可以清零，但后续流程要很小心。
mlock 很难做精确

mlock 锁的是内存页，不是某个 Go 对象。
Go 对象可能和其他数据共用同一页。
slice 可能被复制到未锁页。
Go 栈会增长/移动，敏感数据可能短暂出现在别处。
所以 Go 里 mlock(slice) 只能算“尽力而为”，不能保证。
core dump / ptrace 可以做进程级加固，但不是绝对

setrlimit(RLIMIT_CORE, 0)：防 core dump。
Linux prctl(PR_SET_DUMPABLE, 0)：降低同用户 ptrace/proc 读取风险。
这些比 mlock 更值得优先做。
但 root/管理员仍然能读。
剪贴板是更大的暴露面

一旦写入系统剪贴板，就超出 Go 进程控制。
其他应用、剪贴板管理器、系统同步服务都可能看到。
所以“内存清零”重要，但剪贴板威胁也不能忽视。
