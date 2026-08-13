---
date: "2026-07-30T15:48:36+08:00"
title: "Sql"
categories:
    - SQL
tags:
---

# DDL/DML/DQL/DQL

DDL（Data Definition Language，数据定义语言） CREATE、ALTER、DROP和TRUNCATE

DML（Data Manipulation Language，数据操作语言） 主要是insert、update、delete

DQL（Data Query Language，数据查询语言） 主要是SELECT

DCL（Data Control Language，数据控制语言） 主要是GRANT/REVOKE/SHOW

# schema

Schema（模式/架构）在数据库中就是“命名空间（Namespace）”和“容器”。它就像是数据库里的一个“文件夹”，用来逻辑地组织和隔离数据库对象。

Schema 是一个逻辑容器，里面包含了数据库对象，包括：
表（Tables）
视图（Views）
存储过程（Stored Procedures）
索引（Indexes）
函数（Functions）
触发器（Triggers）

Schema 是权限管理的最小单元。你可以把整个 Schema 的访问权限（增删改查）赋给某个用户，而不需要单独给里面的每张表赋权。比如：GRANT SELECT ON SCHEMA::finance TO analyst_role（允许分析角色查询财务架构下的所有表）。

# Migrate

数据库迁移,用代码（DDL脚本）来“版本化”地管理数据库Schema变化的过程

一次迁移包括一般包括两个文件

Up（升级） 20260730_140000_add_age_column.sql 执行 DDL 往前走（加字段、建表）
Down（回滚） 20260730_140000_add_age_column.sql 执行 DDL 往回退（删字段、删表）

当你要升级数据库到最新版：按顺序执行所有 Up 文件。
当你要回滚到上一个版本：执行最后一个 Down 文件。

# REFERENCES

```sql
CREATE TABLE IF NOT EXISTS blob_sync (
  blob_hash   BLOB    NOT NULL REFERENCES blob(content_hash)        ON DELETE CASCADE,
  target_id   INTEGER NOT NULL REFERENCES sync_target(id),
  remote_path TEXT,                                           -- e.g. ab/cd/<hash>
  synced_at   INTEGER NOT NULL,
  PRIMARY KEY(blob_hash, target_id)
);
```

REFERENCES:
blob_hash 这一列的值必须再 blob表的content_hash列中存在。

ON DELETE CASCADE(级联删除):
blob 表中某行的 content_hash 被删除时，当前表中所有引用那个 content_hash 的行也会自动被删除。
