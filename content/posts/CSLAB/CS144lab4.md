---
date: '2026-05-27T11:33:58+08:00'
title: 'CS144lab4'
categories:
  - CSLAB
tags:
---

这个lab主要的目的是检测之前实现的tcpreader/sender是否可以在webget中运行

需要把webget里TCPSocket替换为CS144TCPSocket

# socket是怎么工作的?

应用层 HTTP:
webget 构造 GET 请求

传输层 TCP:
TCPSocket 建立连接、可靠传输字节流

网络层 IP:
把 TCP segment 封装成 IPv4 datagram，送往服务器 IP

链路层:
通过 真实网卡把 IP 包一跳一跳发出去

原来的TCPSocket是走的Linux内核的TCP

前几个lab只实现了传输层:

建立连接：三次握手，发送 SYN，接收 SYN/ACK，发送 ACK
可靠传输：序列号、ACK、滑动窗口
重传：超时后重发未确认 segment
流量控制：根据对方 advertised window 控制发送量
关闭连接：处理 FIN/ACK
错误处理：RST

但是并没有实现:

网络层的完整 IP 路由、转发、分片等
链路层的 Ethernet frame、MAC 地址、ARP 等

普通 Linux 程序没法直接把 TCP segment 发到 Internet

前面实现的TCP 在用户态,不能像内核 TCP 那样直接接管真实网卡收发包，所以需要 TUN 提供一个用户态和内核 IP 转发系统之间的接口

CS144TCPSocket
  -> 你写的 TCPPeer
  -> TCPOverIPv4OverTunFdAdapter
  -> tun144
  -> Linux 内核帮你转发 IP 包
  -> Internet

也就是说:
TCP 是你写的
IPv4 封装/解析主要由课程框架帮你做
路由、NAT、真实网卡发送由 Linux 内核帮你做
链路层完全不用你管

```bash
./scripts/tun.sh start 144
cmake --build build --target check_webget
```

# 网络测量

1. 选一个从你的 VM 到这个主机的 RTT 至少 100 ms。

可以用`ping www.cs.ox.ac.uk`

看输出里的 time=... ms,如果大于 100 ms，就可以用。

用mtr来观察 VM 到远程主机经过哪些路由节点 `mtr codeforces.com`


```
                                   My traceroute  [v0.95]
aliyun (172.25.156.83) -> codeforces.com (172.67.68.254)           2026-05-27T14:25:52+0800
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                                   Packets               Pings
 Host                                            Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. 10.220.141.106                               88.2%    18    3.9   9.4   3.9  14.8   7.7
 2. 11.73.71.13                                  55.6%    18    3.0   3.2   2.6   4.0   0.5
 3. 10.54.101.218                                 0.0%    18    3.4  19.7   2.9 133.5  39.8
 4. 10.255.39.90                                  0.0%    18    2.6   2.5   2.4   2.7   0.1
 5. 10.216.239.50                                 0.0%    18    3.7   4.2   3.6  12.3   2.0
 6. dunan.cn                                     33.3%    18    4.8   4.1   3.6   5.2   0.5
 7. 220.191.200.243                               0.0%    18    7.6   8.4   7.4  16.6   2.3
 8. (waiting for reply)
 9. (waiting for reply)
10. 202.97.39.153                                75.0%    17   13.3  13.6  13.3  13.8   0.2
11. 202.97.111.54                                 5.9%    17  442.3 290.4 175.0 510.2 106.1
12. 81.173.21.18                                 11.8%    17  181.5 186.2 179.4 209.2   9.8
13. 162.158.84.78                                17.6%    17  203.4 202.2 201.3 203.4   0.6
14. 162.158.84.29                                18.8%    17  201.4 207.1 201.2 235.6  10.4
15. 172.67.68.254                                 0.0%    17  195.9 195.8 195.7 195.9   0.1
```