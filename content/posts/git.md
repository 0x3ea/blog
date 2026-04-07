---
date: '2026-04-05T00:04:24+08:00'
title: 'Git'
categories:
  - Git
---

# worktree

从同一仓库同时检出多个分支到不同的目录

假如你需要一边在 `main` 上修 `bug`,一边在 `feature` 上开发,如果没有 `worktree` 就需要来回切换分支，如果忘了提交

```
# 创建一个 worktree，基于 main 分支，放到 ../hotfix 目录
git worktree add ../hotfix main

# 创建一个 worktree 并新建分支
git worktree add -b feature-x ../feature-x main

# 列出所有worktree
git worktree list

# 用完后删除
git worktree remove ../hotfix
```

与 `git clone` 相比：

使用同一个仓库,分支/提交互通，磁盘占用相对较小（共享对象）

与 `git switch` 相比：

`git switch`切换分支时工作区会被完全替换，如果有未提交的改动可能丢失或冲突


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
# stash

git stash 把你当前未提交的更改（工作区和暂存区）临时藏起来，让工作区恢复到干净状态。这样你就可以安全地 git pull 拉取远程更新。git stash pop 再把之前藏起来的更改恢复回来。

简单说就是：临时保存你的改动，腾出空间来拉代码