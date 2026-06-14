---
date: '2026-05-28T08:43:05+08:00'
title: 'CS144lab5'
categories:
  - CSLAB
tags:
---

# Ethernet address

以太网地址/MAC地址

MAC 地址是网卡/网络 **接口** 在链路层的标识

有线网卡：一个 MAC 地址
Wi-Fi 网卡：一个 MAC 地址
蓝牙网卡：一个 MAC 地址

理论上mac地址是全球唯一的,但是实际上可以被修改或伪造( MAC spoofing)

现代系统(手机或笔记本)连接 Wi-Fi 时，为了隐私，可能会对不同网络使用随机 MAC 地址。

# ARP 缓存

NetworkInterface 里保存的一张临时表

记录了IP 地址 -> MAC 地址的映射

ARP 关心的是：在当前这个局域网 / 二层链路上，某个 IPv4 地址由哪个 MAC 地址接收。

为什么需要ARP缓存?

IP 指明“最终目的地以及路由选择的大方向(todo,说明为什么不是恒定的)；

在不同路由器跳转时,会根据路由器的路由表来决定下一步往哪走

```
目的网段              下一跳
8.8.8.0/24           10.1.1.2
8.0.0.0/8            10.2.2.2
0.0.0.0/0            10.9.9.9
```

MAC 指明“当前这一跳要交给哪个网络接口”。



(TCPSenderMessage/TCPReceiverMessage/TCPMessage)作为TCP segment的playload
TCP segment        传输层
封装进
IPv4 datagram      网络层，也就是 InternetDatagram
封装进
Ethernet frame     链路层

Ethernet frame
└── IPv4 datagram / InternetDatagram
    └── TCP segment



# TODO

lab5 要实现 `network_interface.hh` 的三个方法 `send_datagram`,`recv_frame`,`tick`

## send_datagram( const InternetDatagram& dgram, const Address& next_hop )
把IPv4 datagram 发送到指定地址

1. 判断arp缓存是是否有next_hop对应的mac地址

  1.1. 有mac地址,直接发送
  1.2. 没有mac地址,先把dgram暂存(waiting_datagrams_),先去找next_hop对应的(发送广播),等找到了(recv_frame),再发

这里要注意:

1.arp缓存里没有对应的mac地址!= 需要去查

应该是查之间要有一个时间间隔(30s),需要手动维护(arp_request_timer_)这个信息,只有距离上次查询足够长,才会再次查询


## recv_frame( const EthernetFrame& frame )

接受发来的frame

这里的情况比较复杂

1.接受到了不该接受的(不该发向自己的/不相关的广播)->直接return

2.是自己该处理的

  2.1. 看frame.header.type(这个 Ethernet frame 的 payload 里面装的是什么协议的数据)

  2.2.1 frame.header.type == EthernetHeader::TYPE_ARP,收到frame是以前arp查询的返回

    2.2.1.1 同步更新arp缓存

    2.2.1.2 更新waiting_datagrams_,把能发的消息发掉

    2.2.1.3 OPCODE_REQUEST(查询mac地址)





## tick( const size_t ms_since_last_tick )

模拟时间流动

1.更新arp缓存

2.更新arp_request_timer_

