---
title: Linux 常用命令
date: '2026-04-01'
categories:
  - Linux
tags:
  - Linux
---

## 文本检索

### 日志查看

假如日志是这样的：

`2026-04-14 19:36:47  | INFO  | pool-2-COKRequestHandler-thread-26 | c.e.cok.joymeng.KSTask.KSTaskService-10 | KSTaskService | grantTaskReward success | 10223885000010 | taskId: 80000004 | originStatus: 2 | receiveWay: email`

以下示例中的关键字请替换为自己日志中的实际内容。

多关键字筛选：`awk '/grantTaskReward success/ && /10223885000010/ && /2026-04-15/' smartfox.log.2026-04-*`

`grep -n "grantTaskReward success" smartfox.log.2026-04-14* | grep 10223885000010`

行太长时，可以只提取部分字段：

`awk -F '|' '/10223885000010/ && /grantTaskReward success/ {print $6, $7, $8}' smartfox.log.2026-04-14*`

查看 `grep` 关键字附近的内容：

```bash
grep -C 3 xxx filename # 显示匹配行上下各 3 行
grep -B 3 xxx filename # 显示匹配行上 3 行
grep -A 3 xxx filename # 显示匹配行下 3 行
```

### 忽视大小写

匹配时忽略大小写，使用 `grep -i`。

## 文件与目录

### 文件权限

查看文件权限：`ls -l filename`

Linux 的文件权限分为读、写、执行，分别对应 r、w、x。权限按三类对象设置：所有者、所属组、其他用户，每类各占三个比特位，因此一组权限可简化为一个三位的八进制数字（0～7），例如 `755`。

权限字符串每一位的含义如下：

```
-rwxr-xr-x
| |  |  |
| |  |  +-- 其他用户权限 (r-x)
| |  +------ 所属组权限 (r-x)
| +---------- 文件所有者权限 (rwx)
+----------- 文件类型 (- 普通文件, d 目录, l 链接)
```

除了基础权限，Linux 还有三种特殊权限：

| 值 | 二进制 | 权限         | 作用                                      |
| - | --- | ---------- | --------------------------------------- |
| 4 | 100 | **SUID**   | 执行时以文件所有者权限运行（仅对可执行文件有效）                |
| 2 | 010 | **SGID**   | 执行时以文件所属组权限运行；目录下新建文件继承组                |
| 1 | 001 | **Sticky** | 目录下只有文件所有者、目录所有者或 root 能删除该目录下的文件（如 `/tmp`） |

当特殊权限位生效时，对应的 `x` 会被替换为其他字符：

- SUID 生效时，所有者的 `x` 显示为 `s`（如 `-rwsr-xr-x`，对应 `4755`）。
- SGID 生效时，所属组的 `x` 显示为 `s`（如 `-rwxr-sr-x`，对应 `2755`）。
- Sticky 生效时，其他用户的 `x` 显示为 `t`（如 `drwxrwxrwt`，对应 `/tmp` 的 `1777`）。

把特殊权限放在基础权限前面，就得到四位八进制的完整格式（如 `4755` 表示 SUID + `755`）。

```bash
chmod u+x filename  # 给当前用户添加执行权限
chmod +x filename   # 给可执行文件添加执行权限
chmod 755 filename  # 设置基础权限
chmod 4755 filename # 设置 SUID + 755
```

修改文件所有者：`chown user:group filename`

### 文件属性与类型

查看文件属性：`stat filename`

查看文件类型：`file filename`

获取文件的绝对路径：`realpath filename`

下面是 `file /usr/bin/env` 的输出：

```
env: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=f8a1fb744a7f9a90bc9545f1797fe078a343607b, for GNU/Linux 4.4.0, stripped
```

| 字段 | 含义 |
|------|------|
| **env:** | 文件名就是 `env`，这是 Linux 系统中设置环境变量或查找命令路径的工具 |
| **ELF** | Executable and Linkable Format，Linux 下标准的可执行文件格式 |
| **64-bit** | 64 位程序，只能在 x86-64 架构上运行，或通过兼容层运行 |
| **LSB** | Least Significant Byte first，即**小端字节序**（x86 架构都是小端） |
| **pie executable** | **Position Independent Executable**，位置无关可执行文件。这是现代安全特性，每次运行时地址随机化（ASLR），增强安全性 |
| **x86-64** | 目标架构，即 AMD64/Intel 64 位 |
| **version 1 (SYSV)** | ELF 版本号，SYSV 表示 System V ABI（Unix 系统的标准二进制接口） |
| **dynamically linked** | 动态链接，运行时依赖系统里的共享库（.so 文件） |
| **interpreter /lib64/ld-linux-x86-64.so.2** | 动态链接器路径，程序启动时由它加载所需的共享库，这是 64 位 Linux 的标准链接器 |
| **BuildID[sha1]=f8a1fb...** | 编译时生成的唯一标识符，用于调试时匹配符号文件，`sha1` 表示用 SHA-1 算法计算 |
| **for GNU/Linux 4.4.0** | 编译时针对的最低 Linux 内核版本。4.4.0 意味着需要在 **Linux 4.4 或更高版本**上运行 |
| **stripped** | 符号表已被移除，文件更小，无法直接调试，看不到函数名和变量名，这是发布版二进制文件的常见做法 |

### inode

Linux 目录/文件在系统中的唯一标识，存储了除文件名和文件内容之外的所有信息。

| 字段 | 内容 |
|------|------|
| 文件大小 | 字节数 |
| 权限 | rwxr-xr-x 等 |
| 所有者 | UID（用户 ID） |
| 所属组 | GID（组 ID） |
| 时间戳 | 访问时间、修改时间、状态改变时间 |
| 链接计数 | 有多少个文件名指向这个 inode（硬连接数） |
| 数据块指针 | 文件内容实际存放在磁盘哪些位置（直接/间接指针） |

```bash
ls -i a.txt # 查看inode编号
stat file.txt # 详细 inode 信息
```

删除文件时（`rm file.txt`）：

1. 在目录中删除 “file.txt ↔ inode 1234567” 的映射。
2. 将 inode 1234567 的链接计数减 1。
3. 只有当链接计数变为 0 时，才真正释放 inode 和数据块。

### 软连接/硬连接

软连接：

类似 Windows 的快捷方式，创建一个指向原文件路径的独立文件。软连接有自己的 inode，与原文件不同。

硬连接：

给同一个文件数据取另一个名字。硬连接与原文件共享同一个 inode，inode 编号相同。

硬连接的限制：

- 不能跨磁盘分区（因为 inode 是分区内唯一的）。
- 不能对目录创建硬连接（防止文件系统出现循环引用）。

### touch

创建文件：

```bash
touch {a,b,c,d}.log        # 创建 a.log b.log c.log d.log
```

### mktemp

创建临时文件或目录。`mktemp` 默认创建临时文件，`mktemp -d` 创建临时目录。

## 系统信息

### nproc

显示当前可用的 CPU 核心数量（包括物理核心和逻辑核心，如超线程产生的线程）。

```bash
# 显示当前进程可用的 CPU 核心数（受 cgroups 限制）
nproc          # 输出：8
# 显示系统物理 CPU 核心总数（忽略资源限制）
nproc --all    # 输出：16
```

若系统有超线程（Hyper-Threading），nproc 显示的数值 = 物理核心数 × 线程数。在容器或受 cgroups 限制的环境中，nproc 可能显示分配的核心数而非物理总数。

### lscpu

显示 CPU 架构的详细信息，包括物理核心、逻辑核心、CPU 型号、缓存、NUMA 节点等。

## 归档

### 压缩与解压

压缩文件：

```shell
tar -czf archive.tar.gz file1 file2
```

- `-c`：创建（Create）一个新的归档文件
- `-z`：在打包的同时，使用 gzip 程序（gzip）进行压缩
- `-f`：代表指定文件名（File）

解压文件：

```bash
tar -xzf archive.tar.gz -C /path/to/destination
```

- `-x`：extract，解压。
- `-z`：通过 gzip 处理 `.gz` 文件。
- `-f`：指定归档文件名，后面紧跟文件名。
- `-C`：切换目标目录；目录不存在会报错，需要先 `mkdir -p`。

查看文件大小：

```bash
ls -lh filename
```

## 网络

### traceroute

traceroute 利用 IP 数据包里的 TTL（生存时间）字段来工作。它先发送一个 TTL=1 的数据包，到达第一个路由器后，TTL 降为 0，数据包被丢弃，该路由器会返回一个“超时”通知，从而得到第一跳的信息。接着再发送 TTL=2 的数据包，以此类推，直到最终到达目的地。

展示从你到目标主机需要经过哪些路由器（跳数），并告诉你每一跳的延迟时间。

### mtr

My Traceroute

将 ping 和 traceroute 的功能合二为一，进行持续性探测，而不是只测一次就结束。

核心作用：实时动态地显示每一跳的丢包率和平均延迟，能更准确地反映网络质量的抖动情况。

典型输出：一个实时刷新的表格，除了显示路径外，重点统计了每一跳的丢包率（Loss%）、平均延迟（Avg）、最差延迟（Wrst）等历史数据。

适用场景：排查间歇性卡顿、某段链路持续丢包等复杂问题，这是 traceroute 单次探测很难发现的。

## Shell 与输入输出

### 文件描述符

Linux 把每个输入输出都看成文件，每个打开的文件分配一个文件描述符（file descriptor）：

| 描述符 | 名称 | 含义 |
|--------|------|------|
| 0 | stdin | 标准输入 |
| 1 | stdout | 标准输出（正常信息） |
| 2 | stderr | 标准错误（报错信息） |

`/dev/null`：一个特殊的“黑洞”文件，扔进去的东西都会被丢弃。

### 退出码

程序结束时会产生一个退出码，表示程序的结束状态：

0（成功）/非 0（失败）

### history

查看最近 100 条命令：`history 100`

### tee

把标准输入同时输出到屏幕和文件：

`command | tee file.txt`

### tmux

`tmux new -s pingtest`

detach：Ctrl-b，再按 d

`tmux attach -t pingtest`（再次进入）

`tmux ls`

## 错误代码

| 错误码 | 含义 |
|--------|------|
| EACCES | 权限不足（Permission denied，EACCES = Error Access） |
| ENOENT | 文件不存在（No such file） |
| EISDIR | 是目录而不是文件 |
| ENOSPC | 磁盘空间不足 |
