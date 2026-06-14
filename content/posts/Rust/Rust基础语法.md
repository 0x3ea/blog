---
date: '2026-05-19T08:52:31+08:00'
title: 'Rust基础语法'
categories:
  - Rust
tags:
---

# 基础语法

# Option

```rust
enum Option<T> {
    Some(T),
    None,
}
```
## Some
一个值可能存在，也可能不存在。

## ok_or

## ok_or_else

的方法,把Option<T>转换为Result<T,E>

option.ok_or_else(|| error_value)

等价于下面
```rust
match option {
    Some(v) => Ok(v),
    None => Err(error),
}
```

经常会搭配?使用

let port = config.port.ok_or_else(|| "missing port".to_string())?;

Ok(value)  -> 把 value 取出来，赋给 port
Err(error) -> 直接从当前函数返回 Err(error)

# Result

大致结构如下
```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```
## Ok
这是一个成功的结果，里面装着 42。

## map_err

用来只转换错误值 Err，不动成功值 Ok

```rust
let result: Result<i32, &str> = Err("bad number");

let result2: Result<i32, String> = result.map_err(|e| {
    e.to_string()
});
```

如果是 Err(e)，就把错误 e 转换成另一个错误类型。


unwarp vs ?

## Err

Err是Rust里Rusult枚举的一个变体
```rust
enum Result<T,E>{
    Ok(T),
    Err(E),
}
Err("file not exit")
```

 - self:: 是模块路径前缀，表示当前模块里的自由函数
  - Self:: 是类型别名，表示当前 impl 块的类型（即 IndexDb）

  enumerate:在迭代时同时获取元素的索引和值。

  Path PathBuf

  Path：动态大小的类型（DST），只读引用，不拥有数据

PathBuf：可增长、可修改的路径缓冲区，拥有数据