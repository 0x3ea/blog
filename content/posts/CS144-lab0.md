---
date: '2026-04-07T23:24:18+08:00'
title: 'CS144-Lab0'
categories:
    - CS
tags:
---

# 3.1 Fetch a Web page
```shell
# 通过 DNS 解析拿到 IP → 建立 TCP 连接
telnet cs144.keithw.org http
GET /lab0/123456 HTTP/1.1
# 访问IP(服务器)的cs144.keithw.org域名（一台服务器可能托管多个域名）
Host: cs144.keithw.org
Connection: close
```

# 3.3 Listening and connecting

在本地建立一个简单的 `server` 和 `client`
```shell
netcat-v-l-p 9090
telnet localhost 9090
```

数据报(Internet datagrams)

底层的互联网的实现并不是telnet-netcat这样的字节流,而是数据表,这种方式并不可靠,可能会出现:

丢失 - 数据报在传输途中消失
乱序 - 后发的先到，先发的后到
损坏 - 内容被修改（虽然很少见）
重复 - 同一个数据报收到多次