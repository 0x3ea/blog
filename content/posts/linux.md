---
title: Linux 常用命令
date: '2026-04-01'
categories:
  - Linux
tags:
  - Linux
---

## 日志查看

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

## 常用辅助命令

查看最近 100 条命令：`history 100`

获取文件的绝对路径：`realpath filename`

## 文件权限

查看文件权限：`ls -l filename`

Linux 的文件权限分为读、写、执行，分别对应 r、w、x。

读、写、执行三种权限各占一个比特位，恰好可以用一个三位的八进制数（0–7）表示一组权限。

特殊权限：

| 值 | 二进制 | 权限         | 作用                                      |
| - | --- | ---------- | --------------------------------------- |
| 4 | 100 | **SUID**   | 执行时以文件所有者权限运行（仅对可执行文件有效）                |
| 2 | 010 | **SGID**   | 执行时以文件所属组权限运行；目录下新建文件继承组                |
| 1 | 001 | **Sticky** | 目录下只有文件所有者、目录所有者或 root 能删除该目录下的文件（如 `/tmp`） |

Linux 提供了两种表示文件权限的格式：

1. 基础权限：所有者、所属组、其他用户三类权限各占三个比特位，可简化为三个八进制数字（如 `755`）。
2. 完整权限：特殊权限 + 基础权限，可简化为四个八进制数字（如 `4755`）。

```
-rwxr-xr-x
| |  |  |
| |  |  +-- 其他用户权限 (r-x)
| |  +------ 所属组权限 (r-x)
| +---------- 文件所有者权限 (rwx)
+----------- 文件类型 (- 普通文件, d 目录, l 链接)
```

当特殊权限位生效时，对应的 `x` 会被替换为其他字符：

- SUID 生效时，所有者的 `x` 显示为 `s`（如 `-rwsr-xr-x`，对应 `4755`）。
- SGID 生效时，所属组的 `x` 显示为 `s`（如 `-rwxr-sr-x`，对应 `2755`）。
- Sticky 生效时，其他用户的 `x` 显示为 `t`（如 `drwxrwxrwt`，对应 `/tmp` 的 `1777`）。

```bash
chmod u+x filename  # 给当前用户添加执行权限
chmod +x filename   # 给可执行文件添加执行权限
chmod 755 filename  # 设置基础权限
chmod 4755 filename # 设置 SUID + 755
```

修改文件所有者：`chown user:group filename`

## 压缩与解压

解压文件：

```bash
tar -xzf archive.tar.gz -C /path/to/destination
```

- `-x`：extract，解压。
- `-z`：通过 gzip 处理 `.gz` 文件。
- `-f`：指定归档文件名，后面紧跟文件名。
- `-C`：切换目标目录；目录不存在会报错，需要先 `mkdir -p`。
