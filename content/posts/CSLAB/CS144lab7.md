---
date: '2026-05-29T17:43:52+08:00'
title: 'CS144lab7'
categories:
  - CSLAB
tags:
---

连接建立层面：先 server，再 client
数据流向层面：谁重定向 stdin，谁就是发送方；谁重定向 stdout，谁就是接收方。
```bash
./endtoend server cs144.keithw.org 3000
./endtoend client cs144.keithw.org 3001
./endtoend server cs144.keithw.org 3000 > ./cs144_2mb.txt //接受
./endtoend client cs144.keithw.org 3001 < ~/pingtest/data.txt //发送
```