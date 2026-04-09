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

```cpp
#include <arpa/inet.h>
#include <netdb.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

int main() {
    // 1. 创建 socket
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket");
        return 1;
    }

    // 2. 解析域名并连接服务器
    struct addrinfo hints = {0}, *res;
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;

    if (getaddrinfo("cs144.keithw.org", "80", &hints, &res) != 0) {
        perror("getaddrinfo");
        return 1;
    }

    if (connect(sockfd, res->ai_addr, res->ai_addrlen) < 0) {
        perror("connect");
        freeaddrinfo(res);
        return 1;
    }
    freeaddrinfo(res);

    // 3. 发送 HTTP 请求
    char *request = "GET /hello HTTP/1.1\r\n"
                    "Host: cs144.keithw.org\r\n"
                    "Connection: close\r\n"
                    "\r\n";

    if (send(sockfd, request, strlen(request), 0) < 0) {
        perror("send");
        return 1;
    }

    // 4. 接收响应
    char buffer[4096];
    int bytes_received;
    while ((bytes_received = recv(sockfd, buffer, sizeof(buffer) - 1, 0)) > 0) {
        buffer[bytes_received] = '\0';
        printf("%s", buffer);
    }

    // 5. 关闭连接
    close(sockfd);

    return 0;
}
```

```cpp
void get_URL(const string &host, const string &path) {
    cerr << "Function called: get_URL(" << host << ", " << path << ")\n";
    TCPSocket socket = TCPSocket();
    Address address = Address(host, "http");
    socket.connect(address);
    string requset = "GET /hello HTTP/1.1\r\n"
                     "Host: cs144.keithw.org\r\n"
                     "Connection: close\r\n"
                     "\r\n";
    socket.write(requset);
    string response;
    while (!socket.eof()) {
        string buffer = "";
        socket.read(buffer);
        response += buffer;
    }
    std::cout << "receive meeage: " << response << "\r\n";
    socket.close();
}
```