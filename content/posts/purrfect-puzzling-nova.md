---
title: web
date: '2026-04-07'
categories:
  - CS
---

# 计算机网络系统学习计划（实验驱动版）

## 📋 Context

针对**有基础学习者**定制的实验驱动型学习计划，每周5-10小时，以Stanford CS144为核心，通过从零实现TCP/IP协议栈来系统掌握计算机网络知识。

## 🎯 学习目标

1. **核心目标**：从零实现一个完整的TCP/IP协议栈
2. 系统掌握计算机网络的五层协议栈
3. 通过实践理解Internet核心协议的工作原理
4. 培养网络问题分析与排查能力
5. 提升系统级编程能力（C++）

## 📚 核心学习资源

### 🚀 主线课程：Stanford CS144

**课程信息：**
- **官网**：[cs144.github.io](https://cs144.github.io/)
- **核心理念**：通过实现一个完整的TCP/IP协议栈来学习网络
- **编程语言**：C++
- **中文学习指南**：[CS144指南](https://csdiy.wiki/en/计算机网络/CS144/)

**实验列表（8个Lab）：**
1. **Lab 0**: Networking warmup - 网络编程热身
2. **Lab 1**: Finishing TCP - 完成TCP接收端
3. **Lab 2**: TCP retransmitter - TCP超时重传
4. **Lab 3**: The TCP sender - TCP发送端
5. **Lab 4**: The network interface - 网络接口层
6. **Lab 5**: Network interfaces and routing - 网络接口与路由
7. **Lab 6**: IP forwarding router - IP转发路由器
8. **Lab 7**: NAT-based web proxy - NAT网络代理

**学习资源：**
- [官方课程网站](https://cs144.github.io/)
- [官方Syllabus](https://cs144.github.io/schedule.html)
- [视频课程](https://www.youtube.com/playlist?list=PL6SE8OxqJ2fXL11j9Qgmy9CMfICF_k2tz)
- [实验说明文档](https://cs144.github.io/assignments.html)
- [参考实现讨论](https://cs144.github.io/reference.html)

### 📖 配套阅读资料

1. **《计算机网络：自顶向下方法》** - 选读相关章节
   - [中文版PDF](https://github.com/TimorYang/Computer-Networking-Keith-Ross)
   - [CS DIY学习指南](https://csdiy.wiki/计算机网络/topdown/)

2. **CS144中文学习指南**
   - 详细的学习路线和踩坑经验
   - 每个Lab的要点分析

### 🔧 实验工具

- **Wireshark**: 抓包分析（可选辅助工具）
- **tmate**: 用于Lab自动测试
- **Docker**: 实验环境容器化

### 视频课程

1. **中国科学技术大学课程（B站）**
   - 链接：[Bilibili](https://www.bilibili.com/video/BV1JV411t7ow/)
   - 基于第7版教材的完整课程

2. **Stanford CS144讲座**
   - YouTube播放列表，112个视频
   - 作者：Philip Levis & Nick McKeown

### 实验工具

1. **Wireshark** - 网络协议分析器
   - 官方实验：[Wireshark Labs](https://gaia.cs.umass.edu/kurose_ross/wireshark.php)
   - 南京大学实验：[NJU Network Labs](https://shellqiqi.github.io/nju-network-labs/content/ch01/wireshark.html)

2. **Mininet** - 网络仿真平台
   - 创建虚拟网络拓扑
   - 支持Wireshark集成

3. **Packet Tracer** - Cisco网络模拟器
   - 图形化网络设计工具

## 📅 16周学习计划（每周5-10小时）

### 阶段0：环境准备（第0周）

**任务：**
1. 安装实验环境
2. 熟悉C++基础
3. 克隆CS144仓库

**环境配置：**
```bash
# 安装依赖（Ubuntu/WSL）
sudo apt update
sudo apt install -y build-essential cmake git

# 克隆实验框架
git clone https://github.com/cs144/minnowboard
# 或使用课程提供的staging仓库
```

**参考阅读：**
- [CS144 Lab Checkpoint 0](https://cs144.github.io/assignments/check0.pdf)

---

### 阶段1：TCP实现（第1-8周）

#### 第1-2周：Lab 0 + Lab 1

**Lab 0: Networking Warmup**
- **目标**：熟悉网络编程基础
- **内容**：
  - 字节流读写操作
  - 简单的TCP客户端实现
  - 网络字节序处理
- **时间**：1周
- **验收**：通过`make check`

**Lab 1: TCP Receiver**
- **目标**：实现TCP接收端
- **内容**：
  - TCP段重组（Reassembly）
  - 处理乱序到达的报文段
  - 流量控制（Window size）
- **时间**：1-2周
- **核心概念**：
  - Sequence number & ACK number
  - Reassembly buffer
  - Window size管理

**配套阅读：**
- Kurose&Ross 第3章（传输层）
- CS144 Lecture 3-5

---

#### 第3-4周：Lab 2 + Lab 3

**Lab 2: TCP Retransmitter**
- **目标**：实现超时重传机制
- **内容**：
  - 超时计算与RTO估计
  - 重传定时器管理
  - 指数退避算法
- **时间**：1周
- **核心概念**：
  - Timeout estimation
  - Exponential backoff

**Lab 3: TCP Sender**
- **目标**：实现完整的TCP发送端
- **内容**：
  - 可靠数据传输
  - 流量控制
  - 拥塞控制（可选）
- **时间**：1-2周
- **核心概念**：
  - Retransmission logic
  - Congestion window

**配套阅读：**
- TCP RFC 793（可选）
- Kurose&Ross 第3.5-3.7节

---

#### 第5-6周：Lab 4

**Lab 4: The Network Interface**
- **目标**：实现网络接口层
- **内容**：
  - 以太网帧封装
  - ARP协议（简化版）
  - 网络接口队列管理
- **时间**：2周
- **核心概念**：
  - Ethernet frame格式
  - MAC地址
  - 网络接口抽象

**配套阅读：**
- Kurose&Ross 第6章（链路层）

---

#### 第7-8周：Lab 5 + Lab 6

**Lab 5: Network Interfaces and Routing**
- **目标**：实现多接口与路由
- **内容**：
  - 多网络接口管理
  - 路由表查找
  - 数据帧转发
- **时间**：1-2周

**Lab 6: IP Forwarding Router**
- **目标**：实现IP层路由器
- **内容**：
  - IP数据报解析
  - 路由表匹配（最长前缀匹配）
  - TTL处理
  - ICMP（简化）
- **时间**：1-2周
- **核心概念**：
  - IP forwarding
  - Routing table
  - Longest prefix match

**配套阅读：**
- Kurose&Ross 第4章（网络层）

---

### 阶段2：应用层与进阶（第9-12周）

#### 第9-10周：Lab 7

**Lab 7: NAT-based Web Proxy**
- **目标**：实现NAT网络代理
- **内容**：
  - NAT地址转换
  - TCP连接复用
  - HTTP代理实现
- **时间**：2周
- **核心概念**：
  - NAT原理
  - Connection tracking
  - HTTP协议

---

#### 第11-12周：补充实验与深化

**选项1：Wireshark实验**
- 抓包分析自己实现的协议栈
- 对比真实TCP与实现的差异

**选项2：性能优化**
- 优化TCP拥塞控制
- 提高吞吐量

**选项3：扩展功能**
- 实现更多TCP选项
- 添加IPv6支持

---

### 阶段3：综合项目（第13-16周）

#### 最终项目选择（选一）：

**项目A：完整协议栈测试**
- 搭建测试网络
- 实现端到端通信
- 性能测试与分析

**项目B：网络应用开发**
- 基于自己的协议栈实现应用
- 如：简单Web服务器

**项目C：协议分析**
- 使用Wireshark深入分析各层协议
- 撰写分析报告

## 🔧 实验环境搭建

### 开发环境

**推荐配置：**
- **操作系统**：Linux (Ubuntu 20.04+ 或 WSL2)
- **编译器**：GCC 9+ / Clang 10+
- **构建工具**：CMake 3.15+
- **编辑器**：VS Code + C/C++插件

**VS Code插件推荐：**
- C/C++ (Microsoft)
- CMake Tools
- Clangd

**依赖安装（Ubuntu/WSL）：**
```bash
sudo apt update
sudo apt install -y \
    build-essential \
    cmake \
    git \
    gdb \
    clang-format \
    valgrind
```

### CS144实验框架

**获取方式：**
1. 课程官方会提供staging仓库
2. 或者使用公开的参考实现学习
   - [PKUFlyingPig/CS144](https://github.com/PKUFlyingPig/CS144-Computer-Network)

**测试工具：**
- tmate（用于自动测试）
- 课程提供的基础测试框架

### 可选辅助工具

1. **Wireshark** - 抓包分析
2. **netcat (nc)** - 网络调试
3. **tcpdump** - 命令行抓包
4. **iperf** - 网络性能测试

## 💡 学习方法建议

### 实验驱动的学习流程

1. **阅读实验文档**（30分钟）
   - 理解实验目标
   - 查看接口定义

2. **运行测试**（15分钟）
   - 先运行现有代码看失败情况
   - 理解测试用例

3. **实现代码**（2-4小时）
   - 小步迭代
   - 频繁测试

4. **调试优化**（1-2小时）
   - 使用gdb调试
   - 查看日志输出

5. **写实验报告**（30分钟）
   - 记录遇到的问题
   - 总结学到的知识

### 调试技巧

```bash
# 使用gdb调试
gdb --args your_program

# Valgrind检查内存泄漏
valgrind --leak-check=full ./your_program

# 网络抓包
sudo tcpdump -i any -n tcp
```

### 时间分配建议（每周8小时）

| 活动 | 时间 |
|------|------|
| 阅读资料 | 2小时 |
| 编码实现 | 4小时 |
| 调试测试 | 1.5小时 |
| 总结笔记 | 0.5小时 |

## 📝 学习方法建议

1. **理论实践结合**：每章理论学习后立即完成对应实验
2. **主动学习**：尝试用自己的话解释概念
3. **问题驱动**：带着问题去学习，遇到问题主动查找资料
4. **记录笔记**：建立个人知识库
5. **参与社区**：加入相关学习社区讨论

## ✅ 验证与测试

### 每个Lab的验收标准

每个Lab都有自动化测试：
```bash
# 运行测试
make check

# 或使用tmate进行自动评分
```

### 学习进度检查

**每周自问：**
1. 这个Lab解决了什么问题？
2. 我的实现如何处理边界情况？
3. 与标准协议实现有何差异？

### 最终成果展示

完成所有Lab后，你将拥有：
- 一个可运行的TCP/IP协议栈
- 可以与其他真实网络节点通信
- 理解网络协议的每个细节

## 📚 关键文件参考

### CS144核心文件

**Lab框架：**
- `libsponge/` - 协议栈实现目录
- `apps/` - 测试应用程序
- `tests/` - 测试用例

**关键接口（需要实现的类）：**
- `TCPReceiver` - TCP接收端
- `TCPSender` - TCP发送端
- `TCPSegment` - TCP段封装
- `NetworkInterface` - 网络接口

## 🆘 常见问题与资源

### 学习资源

**中文社区与指南：**
- [CS DIY - CS144指南](https://csdiy.wiki/en/计算机网络/CS144/) - 强烈推荐！
- [CS144中文学习笔记](https://github.com/yingshaoxo/CS144-Computer-Networking)

**官方资源：**
- [CS144官方课程](https://cs144.github.io/)
- [Lecture视频](https://www.youtube.com/playlist?list=PL6SE8OxqJ2fXL11j9Qgmy9CMfIC_k2tz)
- [课程讨论论坛](https://www.edx.org/course/stanford-introduction-to-computer-networking)

### 参考书籍（按需阅读）

- 《计算机网络：自顶向下方法》相关章节
- TCP/IP Illustrated, Volume 1（可选，进阶）

## 🎓 学习成果

完成本计划后，你将能够：

1. **深度理解** TCP/IP协议栈的每个层次
2. **从零实现** 一个可用的TCP/IP协议栈
3. **掌握** C++网络编程技能
4. **具备** 网络协议设计与实现能力
5. **理解** 网络性能优化的关键点
6. **为深入** 网络安全、分布式系统、云原生打下坚实基础

## 📌 快速开始检查清单

- [ ] 安装Ubuntu/WSL2环境
- [ ] 配置C++开发环境
- [ ] 访问[CS144官网](https://cs144.github.io/)获取最新Lab信息
- [ ] 阅读Lab 0文档
- [ ] 开始第一个实验！
