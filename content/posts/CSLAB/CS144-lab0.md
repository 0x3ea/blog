---
date: '2026-04-07T23:24:18+08:00'
title: 'CS144-Lab0'
categories:
    - CSLAB
tags:
---

lab0 要求实现 get_URL 函数,也就是通过调用CS144提供的相关类,来实现一个 tcp 通信

```
main(argc, argv)
  |
  v
get_URL(host, path)
  |
  +-- Address(host, "http")
  |     把主机名和服务名解析成 IP + port 80
  |
  +-- TCPSocket()
  |     创建一个 TCP socket
  |
  +-- socket.connect(address)
  |     让内核完成 TCP 三次握手
  |
  +-- socket.write(http_request)
  |     把 HTTP 请求写进 TCP 字节流
  |
  +-- while (!socket.eof())
          socket.read(response)
          cout << response

```

tcp
Transmission Control Protocol（传输控制协议）
在 IP 的基础上提供可靠的、有序的、面向连接的数据传输

ip
Internet Protocol（网际协议）
负责将数据包(datagram)从源地址发送到目标地址

应用数据 "Hello"
        ↓
TCP层：加上 TCP Header → 形成 TCP Segment
        ↓
IP层：再加上 IP Header → 形成 IP Datagram
        ↓
链路层：最后加上 Ethernet Header → 形成 Ethernet Frame
        ↓
网络传输