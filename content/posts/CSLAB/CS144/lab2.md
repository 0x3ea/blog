---
date: '2026-05-14T16:02:11+08:00'
title: 'Lab2'
categories:
tags:
---

# 名词解释
seqno: sequence number

ackno: acknowlage number  下一个期望收到的 TCP sequence number 累计确认 cumulative ACK

windows size; 还能接收多少字节

RST:连接出错，需要立刻重置。

ackno       = 我连续收到了哪里，下一个要哪个 seqno
window_size = 我还有多少 buffer 空间
RST         = 连接是否异常，需要重置

FIN 不占 payload stream index
FIN 但占 TCP sequence number

为什么TCP header 里的 window size 字段只有 16 bit?
