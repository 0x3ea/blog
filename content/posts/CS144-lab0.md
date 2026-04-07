---
date: '2026-04-07T23:24:18+08:00'
title: 'CS144-Lab0'
categories:
    - CS
tags:
---

```shell
# 通过 DNS 解析拿到 IP → 建立 TCP 连接
telnet cs144.keithw.org http 
GET /lab0/123456 HTTP/1.1
# 访问IP(服务器)的cs144.keithw.org域名（一台服务器可能托管多个域名）
Host: cs144.keithw.org
Connection: close
```