---
date: '2026-06-08T08:48:33+08:00'
title: 'Anyhow'
categories:
  - Rust
tags:
---

## anyhow::Error

只要错误满足:

std::error::Error + Send + Sync + 'static

就可以被包装成anyhow::Error

## anyhow::Result
anyhow::Result 是Result的一个类型别名

anyhow中这样定义的:

pub type Result<T,E=anyhow::Error> =std::result::Result<T,E>,

也就是

anyhow::Reuslt<T> = std::result::Result<T,anyhow::Error>

anyhow::Result<()> = std::result::Result<(),anyhow::Error>