---
date: '2026-05-21T10:33:42+08:00'
title: 'CS144lab3'
categories:
  - CSLAB
tags:
---

从 ByteStream 读数据

把应用层写入的字节流切成 TCP payload。
每个 segment 不能超过 TCPConfig::MAX_PAYLOAD_SIZE。
不能超过对端通告的 window。
维护 TCP sequence number

SYN 占 1 个 sequence number。
payload 每个字节占 1 个 sequence number。
FIN 占 1 个 sequence number。
RST 不算普通 sequence length。
实现发送窗口

根据 receiver 发来的 window_size 决定还能发多少。
bytes_in_flight 表示已经发出但还没被 ACK 的 sequence number 数量。
可发送空间大致是：

available = window_size - bytes_in_flight
如果 window_size == 0，要按 TCP 规则做 zero-window probing，通常把窗口当作 1 来尝试发送。
记录 outstanding segments

每个发出去但还没被 ACK 的 segment 都要保存。
因为之后可能需要重传。
ACK 到来后，删除已经被完全确认的 segment。
处理 receiver 的 ACK

receive() 会收到 TCPReceiverMessage。
要更新：
对端窗口大小；
已确认到的 sequence number；
outstanding queue；
retransmission timer 状态。
如果 ACK 超过了自己已发送的最大 sequence number，要忽略。
实现重传计时器

tick() 模拟时间流逝。
如果最早 outstanding segment 超时，就重传它。
如果对端窗口非零，RTO 要指数退避：

RTO *= 2;
consecutive_retransmissions++;
如果窗口为零，通常不指数退避。
实现几个主要方法

push(transmit)
尽可能填满发送窗口。
负责发 SYN、payload、FIN。
receive(msg)
处理 ACK、窗口更新、RST。
tick(ms, transmit)
处理超时和重传。
make_empty_message()
构造不占 sequence number 的空 TCP message。
sequence_numbers_in_flight()
返回未确认的 sequence number 数量。
consecutive_retransmissions()
返回连续重传次数。

  // 多久没收到 ACK，就认为最早 outstanding segment 可能丢了，需要重传
  uint64_t current_RTO_ms_;
  // 连续发生了多少次超时重传，而且中间没有收到推进 ACK。
  uint64_t consecutive_retransmissions_;
// 当前 timer 已经累计走了多久
  uint64_t elapsed_ms_;