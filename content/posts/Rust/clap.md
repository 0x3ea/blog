---
date: '2026-06-05T09:37:45+08:00'
title: 'Clap'
categories:
  - Rust
tags:
---

clap是一个命令行解析工具crate

clap提供了两种构建命令的方式:Derive 和 Builder,Derive利用宏,Builder利用构建者模式链式构建

# Derive

```rust
use clap::{Parser, Subcommand};

#[derive(Debug, Parser)]
#[command(name = "crypax")]
#[command(version)]
#[command(about = "Encrypt files or folders into anonymous archive shards")]
pub struct Cli {
    #[command(subcommand)]
    pub command: Command,
}
#[derive(Debug, Subcommand)]
pub enum Command {
    Encrypt {
        source: PathBuf,
        output_dir: PathBuf,
    },
    Decrypt {
        archive_dir: PathBuf,
        output_dir: PathBuf,
    },
    Verify {
        archive_dir: PathBuf,
    },
    Repair {
        archive_dir: PathBuf,
    },
    List,
    Forget {
        target: String,
    },
    Meta {
        #[command(subcommand)]
        command: Metacommand,
    },
}
#[derive(Debug, Subcommand)]
pub enum Metacommand {
    ShowP {
        target: String,
    },
    Set {
        target: String,
        #[arg(long)]
        title: Option<String>,
        #[arg(long)]
        note: Option<String>,
        #[arg(long)]
        tag: Vec<String>,
        #[arg(long)]
        custom: Option<String>,
    },
    Thumbnail {
        target: String,
        image_path: PathBuf,
    },
}
```
## #[derive(Debug, Parser)]

#[derive()]:rust的一个属性（attribute），用于自动为结构体（struct）或枚举（enum）实现特定的 traits（特性）。

比如Debug/Clone/PartialEq 和 Eq/PartialOrd 和 Ord

Debug 是标准库内置支持的派生 trait：自动实现 std::fmt::Debug,之后可以用 println!("{:?}", cli) 调试输出这个结构体

Parser 来自 clap crate,自动为 Cli 生成命令行参数解析能力,之后可以调用Cli::parse(),从命令行参数里解析出 Cli

Default 让struct可以构造空实例
## #[command(version)]

clap 的 Parser 宏看的属性参数

name  命令名
version  版本信息
about 命令信息

字段属性
#[command(subcommand)] 表示这是子命令
#[arg(short, long)] 表示这个字段支持短选项+长选项传入
比如
```rust
#[arg(long)]
tag: Vec<String>,
```
可以--tag a --tag b 或者 -t a -t b

如果不加,字段会变成位置参数,按照声明的顺序

如果加了,就一定要传参数,除非设置了default_value
```rust
#[arg(long, default_value = "untitled")]
title: String
```