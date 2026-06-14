---
date: '2026-06-03T09:48:07+08:00'
title: 'Server'
categories:
  - Linux
tags:
---

sudo journalctl -u ssh -f

禁止 root 登录	编辑 /etc/ssh/sshd_config：PermitRootLogin no	必须
禁用密码认证	编辑 /etc/ssh/sshd_config：PasswordAuthentication no	必须
修改 SSH 端口	编辑 /etc/ssh/sshd_config：Port 2222（改为非标准端口）	强烈推荐
使用 AllowUsers 白名单	编辑 /etc/ssh/sshd_config：AllowUsers x3ea （只允许特定用户登录）	强烈推荐
安装 fail2ban	sudo apt install fail2ban 并配置	强烈推荐

sudo systemctl restart sshd

记一次曲折的修改ssh 端口

配置 阿里云云服务器 ubuntu

起因是我用sudo journalctl -u ssh -f  查看了一下ssh记录?
然后心血来潮想改一下ssh 端口

1.怎么选新端口?

sudo ss -tulnp | grep 14374 来检查新端口是否被占用

2.sudo vim sshd_config ,加入了Port 14374  这时会发现sshd_config里,Prot 22是被注释掉的?


2.sudo systemctl reload sshd 这时报错了:Failed to reload sshd.service: Unit sshd.service not found

系统使用的是 ssh.service 而不是 sshd.service,所以正确命令为sudo systemctl reload ssh

4.除此之外,还需要开放防火墙+服务器安全组
sudo ufw allow 14374/tcp

5.这时还是不行,用sudo ss -tlnp | grep ssh ,输出为
LISTEN 0      4096         0.0.0.0:22         0.0.0.0:*    users:(("sshd",pid=1195,fd=3),("systemd",pid=1,fd=86))
LISTEN 0      4096            [::]:22            [::]:*    users:(("sshd",pid=1195,fd=4),("systemd",pid=1,fd=87))
说明你的 SSH 配置没有生效。即使你改了 /etc/ssh/sshd_config 文件，SSH 服务并没有真正开始监听 14374 端口。

6.sudo journalctl -u ssh -n 50 --no-pager  再看一下日志
Jun 03 10:34:50 aliyun sshd[1195]: Server listening on 0.0.0.0 port 22.
Jun 03 10:34:50 aliyun sshd[1195]: Server listening on :: port 22.
Jun 03 10:39:15 aliyun sshd[1195]: Server listening on 0.0.0.0 port 22.
Jun 03 10:39:15 aliyun sshd[1195]: Server listening on :: port 22.
Jun 03 10:45:05 aliyun sshd[1195]: Server listening on 0.0.0.0 port 22.
Jun 03 10:45:05 aliyun sshd[1195]: Server listening on :: port 22.

每次重启都只有 22，完全没有 14374。说明 配置文件中的 Port 14374 根本没有被 SSH 服务读取到

7.
sudo grep -n "Port" /etc/ssh/sshd_config
15:# configuration must be re-generated after changing Port, AddressFamily, or
23:#Port 22
24:Port 14374
96:#GatewayPorts no

sudo grep -n "Include" /etc/ssh/sshd_config
12:Include /etc/ssh/sshd_config.d/*.conf

sudo systemctl cat ssh | grep -E "ExecStart|EnvironmentFile"
EnvironmentFile=-/etc/default/ssh
ExecStartPre=/usr/sbin/sshd -t
ExecStart=/usr/sbin/sshd -D $SSHD_OPTS

sudo sshd -T | grep -E "port|config"
port 14374
gatewayports no

ls -la /etc/ssh/sshd_config*
-rw-r--r-- 1 root root 3451 Jun  3 10:39 /etc/ssh/sshd_config
-rw-r--r-- 1 root root 3502 Apr 30 06:51 /etc/ssh/sshd_config.ucf-dist

/etc/ssh/sshd_config.d:
total 8
drwxr-xr-x 2 root root 4096 Mar 16 10:24 .
drwxr-xr-x 4 root root 4096 Jun  3 10:39 ..

配置是正确的：sshd -T 命令直接读取并应用了所有配置，它的输出 port 14374 是最高级别的证明。这强有力地说明 /etc/ssh/sshd_config 里的 Port 14374 语法没错，SSH 服务也确实“打算”监听这个端口。

Port 22 被正确注释掉了：#Port 22 确保了服务不会因为遗留配置而监听 22 端口。

Include 指令没有干扰：虽然引用了 /etc/ssh/sshd_config.d/*.conf 目录，但目前该目录为空，不存在其他配置文件覆盖 Port 指令的情况。

问题最可能出在服务启动的实际参数或启动过程中发生了错误上


sshd -T 显示配置正确，但实际运行的进程却没监听相应端口，通常是以下两个原因之一：

SSHD_OPTS 环境变量干扰：systemctl cat ssh 输出显示 ExecStart=/usr/sbin/sshd -D $SSHD_OPTS。这个 $SSHD_OPTS 变量可能从 /etc/default/ssh 文件中加载，并包含了 -p 22 之类的参数，从而覆盖了配置文件里的 Port 14374 设置。

端口绑定失败（静默回退）：SSH 服务在启动时，如果尝试绑定 14374 端口失败（比如权限不足、端口被其他进程占用、SELinux 阻止等），理论上会在日志里报错，然后继续监听 22 端口。但你的日志里没有出现错误，所以这个可能性较低。

8.sudo cat /etc/default/ssh    # Default settings for openssh-server. This file is sourced by /bin/sh from
# /etc/init.d/ssh.

# Options to pass to sshd
SSHD_OPTS=

SSHD_OPTS 是空的，排除了环境变量覆盖的可能性

9.sudo systemctl stop ssh && sudo /usr/sbin/sshd -d -f /etc/ssh/sshd_config 2>&1 | head -50
Stopping 'ssh.service', but its triggering units are still active:
ssh.socket
debug1: sshd version OpenSSH_9.6, OpenSSL 3.0.13 30 Jan 2024
debug1: private host key #0: ssh-rsa SHA256:P7hrBl5uiQnS0Mru1RWFsrVUD+F769hF0z4Sbb5V938
debug1: private host key #1: ecdsa-sha2-nistp256 SHA256:L9+Esxp+q3B/k+P4lQGpaiYEz7VI2r2bxqd8DaF5dYk
debug1: private host key #2: ssh-ed25519 SHA256:9gcLoXxQe8pryKRN7+LgwFR4OzTK/fUSoqn1/DFT0nk
Missing privilege separation directory: /run/sshd

sudo lsof -i :14374
无输出

sudo systemctl status ssh --no-pager | grep -E "CGroup|Main PID"
 Main PID: 1195 (code=exited, status=0/SUCCESS)

sudo journalctl -u ssh --no-pager -n 30
Jun 03 10:38:36 aliyun sshd[43620]: Received disconnect from 218.104.71.178 port 53702:11:  [preauth]
Jun 03 10:38:36 aliyun sshd[43620]: Disconnected from authenticating user x3ea 218.104.71.178 port 53702 [preauth]
Jun 03 10:38:41 aliyun sshd[43622]: dispatch_protocol_error: type 80 seq 2 [preauth]
Jun 03 10:38:46 aliyun sshd[43622]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=218.104.71.178  user=x3ea
Jun 03 10:38:47 aliyun sshd[43622]: Failed password for x3ea from 218.104.71.178 port 56608 ssh2
Jun 03 10:38:48 aliyun sshd[43622]: dispatch_protocol_error: type 80 seq 4 [preauth]
Jun 03 10:38:48 aliyun sshd[43622]: Received disconnect from 218.104.71.178 port 56608:11:  [preauth]
Jun 03 10:38:48 aliyun sshd[43622]: Disconnected from authenticating user x3ea 218.104.71.178 port 56608 [preauth]
Jun 03 10:39:15 aliyun systemd[1]: Reloading ssh.service - OpenBSD Secure Shell server...
Jun 03 10:39:15 aliyun sshd[1195]: Received SIGHUP; restarting.
Jun 03 10:39:15 aliyun sshd[1195]: Server listening on 0.0.0.0 port 22.
Jun 03 10:39:15 aliyun sshd[1195]: Server listening on :: port 22.
Jun 03 10:39:15 aliyun systemd[1]: Reloaded ssh.service - OpenBSD Secure Shell server.
Jun 03 10:40:45 aliyun sshd[43806]: Received disconnect from 218.104.71.178 port 20409:11:  [preauth]
Jun 03 10:40:45 aliyun sshd[43806]: Disconnected from authenticating user x3ea 218.104.71.178 port 20409 [preauth]
Jun 03 10:40:46 aliyun sshd[43810]: Received disconnect from 218.104.71.178 port 20773:11:  [preauth]
Jun 03 10:40:46 aliyun sshd[43810]: Disconnected from authenticating user x3ea 218.104.71.178 port 20773 [preauth]
Jun 03 10:42:50 aliyun sshd[43882]: Connection closed by 8.139.112.115 port 26959
Jun 03 10:45:05 aliyun systemd[1]: Reloading ssh.service - OpenBSD Secure Shell server...
Jun 03 10:45:05 aliyun sshd[1195]: Received SIGHUP; restarting.
Jun 03 10:45:05 aliyun sshd[1195]: Server listening on 0.0.0.0 port 22.
Jun 03 10:45:05 aliyun sshd[1195]: Server listening on :: port 22.
Jun 03 10:45:05 aliyun systemd[1]: Reloaded ssh.service - OpenBSD Secure Shell server.
Jun 03 10:47:41 aliyun sshd[44101]: Connection closed by 8.128.64.52 port 57381
Jun 03 10:52:35 aliyun sshd[44144]: Connection closed by 8.128.98.3 port 58777
Jun 03 10:57:29 aliyun sshd[44185]: Connection closed by 8.128.67.59 port 56795
Jun 03 11:07:06 aliyun systemd[1]: Stopping ssh.service - OpenBSD Secure Shell server...
Jun 03 11:07:06 aliyun systemd[1]: ssh.service: Deactivated successfully.
Jun 03 11:07:06 aliyun systemd[1]: Stopped ssh.service - OpenBSD Secure Shell server.
Jun 03 11:07:06 aliyun systemd[1]: ssh.service: Consumed 1.632s CPU time.

Stopping 'ssh.service', but its triggering units are still active:
ssh.socket

你的系统使用的是 ssh.socket 激活模式，而不是直接启动 ssh.service。
在 socket 激活模式下：

ssh.socket 监听端口（22）

当有连接进来时，ssh.socket 才启动 ssh.service 来处理

这意味着 sshd 进程本身不直接监听端口，而是由 ssh.socket 监听

所以你修改 sshd_config 中的 Port 是无效的，因为真正监听端口的不是 sshd，而是 systemd 的 socket 单元。

修改方案:修改 ssh.socket 监听的端口
（Drop-in 覆盖）：另外写了一个补充协议（override.conf）

10.sudo systemctl edit ssh.socket

[Socket]
ListenStream=14374

# 然后重载并重启
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket

# 验证端口
sudo ss -tlnp | grep 14374

11.
# 1. 直接查看 socket 状态（最关键的）
sudo systemctl status ssh.socket

ssh.socket: Failed to create listening socket ([::]:14374): Address already in use


ssh.service 占用了端口

删除了原来sshd_config 中的 Port 14374,但是sudo systemctl start ssh.socket
 还是失败了



 根据我们之前的对话，我帮你总结一下修改 SSH 端口的完整操作流程，包括踩坑和解决方案。

---

## 📋 完整操作流程总结

### 一、初始目标

将阿里云 Ubuntu 服务器的 SSH 端口从默认的 22 改为 14374，提高安全性。

---

### 二、操作步骤与踩坑记录

#### 第 1 步：修改 sshd_config（第一次踩坑）

**操作**：
```bash
sudo vi /etc/ssh/sshd_config
# 将 #Port 22 改为 Port 14374
```

**踩坑**：
- 修改后重启 SSH 服务，端口仍然是 22，14374 没生效
- 原因：系统使用的是 **socket 激活模式**，不是传统服务模式

**发现过程**：
```bash
sudo systemctl status ssh
# 显示 TriggeredBy: ● ssh.socket
# 说明 ssh.service 是被 socket 触发的
```

**解决方案**：
- 不再修改 sshd_config（因为 socket 模式下这个配置不生效）
- 转而修改 `ssh.socket` 的配置

---

#### 第 2 步：尝试配置 ssh.socket（第二次踩坑）

**操作**：
```bash
sudo systemctl edit ssh.socket
```

在编辑器中添加：
```ini
[Socket]
ListenStream=14374
```

**踩坑**：
- 把配置写在了 `### Edits below this comment will be discarded` 注释**之后**
- 导致配置被 systemd 忽略

**错误日志**：
```
ssh.socket: Failed to create listening socket ([::]:14374): Address already in use
ssh.socket: Failed with result 'resources'
```

**解决方案**：
- 重新编辑，确保配置写在 `### Edits below this comment will be discarded` **之前**
- 或者直接清空文件，只写配置内容

**正确位置**：
```ini
### Editing /etc/systemd/system/ssh.socket.d/override.conf
### Anything between here and the comment below will become the contents of the drop-in file

[Socket]
ListenStream=14374

### Edits below this comment will be discarded
```

---

#### 第 3 步：端口冲突问题（第三次踩坑）

**问题**：
```
ssh.socket: Failed to create listening socket ([::]:14374): Address already in use
```

**原因分析**：
- 有多个地方定义了 `ListenStream`
- 原始文件：`/usr/lib/systemd/system/ssh.socket` 定义了 22 端口
- 自动生成：`/run/systemd/generator/ssh.socket.d/addresses.conf` 定义了 14374
- 手动配置：`/etc/systemd/system/ssh.socket.d/override.conf` 又定义了 14374
- 三个配置叠加，导致 systemd 无法处理

**解决方案**：
```bash
# 1. 清理所有自定义配置
sudo rm -rf /etc/systemd/system/ssh.socket.d

# 2. 禁用自动生成器
sudo systemctl mask sshd-socket-generator

# 3. 清理自动生成的配置
sudo rm -rf /run/systemd/generator/ssh.socket.d

# 4. 重新创建干净的配置
sudo mkdir -p /etc/systemd/system/ssh.socket.d
echo -e "[Socket]\nListenStream=14374\nFreeBind=yes" | sudo tee /etc/systemd/system/ssh.socket.d/override.conf

# 5. 重载并启动
sudo systemctl daemon-reload
sudo systemctl start ssh.socket
```

---

#### 第 4 步：只监听 IPv6 的问题（第四次踩坑）

**问题**：
```bash
ssh -p 14374 localhost
# Connection refused

# 查看监听端口
sudo ss -tlnp | grep 14374
# 只显示 [::]:14374（IPv6），没有 0.0.0.0:14374（IPv4）
```

**原因**：
- 配置 `ListenStream=14374` 默认只监听 IPv6
- `localhost` 默认解析为 IPv4 的 `127.0.0.1`

**解决方案**：
```bash
# 修改配置，同时监听 IPv4 和 IPv6
sudo systemctl edit ssh.socket
```

修改为：
```ini
[Socket]
ListenStream=0.0.0.0:14374
ListenStream=[::]:14374
FreeBind=yes
```

```bash
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket
```

**验证**：
```bash
sudo ss -tlnp | grep 14374
# 应该看到两行：
# LISTEN 0 4096 0.0.0.0:14374 0.0.0.0:*
# LISTEN 0 4096 [::]:14374 [::]:*
```

---

### 三、最终成功状态

```bash
# 监听端口
$ sudo ss -tlnp | grep 14374
LISTEN 0 4096 0.0.0.0:14374 0.0.0.0:* users:(("systemd",pid=1,fd=72))
LISTEN 0 4096 [::]:14374 [::]:* users:(("systemd",pid=1,fd=72))

# SSH 服务状态（由 socket 触发）
$ sudo systemctl status ssh
○ ssh.service - OpenBSD Secure Shell server
     TriggeredBy: ● ssh.socket
     Active: inactive (dead)

# Socket 状态
$ sudo systemctl status ssh.socket
● ssh.socket - OpenBSD Secure Shell server socket
     Listen: 0.0.0.0:14374 (Stream)
             [::]:14374 (Stream)
     Active: active (listening)
```

---

### 四、阿里云安全组配置

在阿里云控制台添加入方向规则：
- 端口：`14374`
- 协议：TCP
- 授权对象：`0.0.0.0/0`（或限制为特定 IP）

---

### 五、踩坑总结

| 序号 | 踩坑内容 | 原因 | 解决方案 |
|:---|:---|:---|:---|
| 1 | 修改 sshd_config 不生效 | 系统使用 socket 激活模式 | 改为修改 ssh.socket |
| 2 | systemd edit 配置被忽略 | 写在了 discard 注释后面 | 确保配置写在注释之前 |
| 3 | Address already in use | 多个配置冲突 | 清理所有配置，重新创建 |
| 4 | 只能监听 IPv6 | ListenStream=14374 默认 IPv6 | 明确指定 0.0.0.0:14374 和 [::]:14374 |
| 5 | ssh.service 占用端口 | 两种模式同时启用 | 确保 ssh.service 已停止和禁用 |

---

### 六、关键命令速查

```bash
# 查看 Socket 配置
sudo systemctl cat ssh.socket

# 编辑 Socket 配置
sudo systemctl edit ssh.socket

# 重启 Socket
sudo systemctl daemon-reload
sudo systemctl restart ssh.socket

# 查看监听端口
sudo ss -tlnp | grep 14374

# 停止传统 SSH 服务（避免冲突）
sudo systemctl stop ssh
sudo systemctl disable ssh

# 测试连接
ssh -p 14374 localhost
```

---

### 七、与 22 端口相比的优势

修改完成后：
- ✅ 22 端口不再对外暴露
- ✅ 14374 端口只有你自己知道
- ✅ 大幅降低被自动化扫描攻击的风险
- ✅ 配合 fail2ban 效果更佳

---

**注意**：以上流程基于 Ubuntu 系统的 socket 激活模式。如果你使用的是其他发行版或传统模式，步骤会有所不同。


当你有一台有静态ip的服务器时,最先需要做的:

1.禁止密码认证

2.改变ssh 端口

3.白名单用户登录
