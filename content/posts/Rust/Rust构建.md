---
date: "2026-07-21T16:08:25+08:00"
title: "Rust构建"
categories:
    - Rust
tags:
---

release profile 优化 / metadata

[profile.release]
opt-level = "z"
lto = true
codegen-units = 1
strip = true
panic = "abort"

选择关闭一些特性
arboard = { version = "3", default-features = false }
