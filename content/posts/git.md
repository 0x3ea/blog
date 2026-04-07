---
date: '2026-04-05T00:04:24+08:00'
title: 'Git'
categories:
  - Git
---

# worktree

从同一仓库同时检出多个分支到不同的目录

# 同步

本地一个目录下只能有一个仓库(.git)

**一个本地仓库** 可以绑定 **多个远程地址**

比如你fork了一个项目(origin),开发了自己版本,上传了自己的版本到github(upstream),别人修改了你的版本,这时你的本地仓库就绑定了多个远程

```shell
git fetch #fetch 所有远程
git fetch origin #只 fetch origin
git log #查看当前分支的所有历史
git log origin/main #查看远程main分支的所有历史
git log --oneline # 当前分支所有历史（一行一条）
git log --all # 所有分支的历史
git log --decorate #显示分支名、标签名等引用信息
git log --graph # 用 ASCII 字符画出分支合并图
git pull orgin/main # git fetch orgin/main + git merge orgin/main
# 注意merge的时候要让本地和远程分支对应
```