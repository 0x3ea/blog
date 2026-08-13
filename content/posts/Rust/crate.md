---
date: "2026-06-16T09:35:58+08:00"
title: "Crate"
categories:
    - Rust
tags:
---

## package/crate/module

package: 一个项目/git仓库

crate: 编译产出的产物( `.exe`/ `.lib`)

一个包只能有一个二进制create吗?

module: 文件夹/命名空间,组织代码、控制可见性

要使用module,需要在模块的**直接父模块**里声明 mod xxx,

如果没有父模块(顶层模块),则写到 crate的根

这个mod xxx 会按规则映射到一个文件上 xxx.rs 或xxx/mod.rs

crate 就是一棵 module 树;每个 module 归属且仅归属一个 crate,不存在"同时跨在两个 crate 上的 module"

如果main.rs和lib.rs都写了 mod config,并且解析到了同一个文件(config.rs或 config/mod.rs),会发生什么?

编译出**两个独立的 `config` module**:一个属于 library crate,一个属于 binary crate
