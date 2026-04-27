---
date: '2026-04-05T00:04:24+08:00'
title: 'Git'
categories:
  - Git
---

本文记录 Git 常用操作，按学习路径组织：基础概念 → 基础配置 → 分支操作 → 远程协作 → 高级操作。

# 基础概念

## 工作区、暂存区、本地仓库

```
编辑文件（工作区） ──→ git add ──→ 暂存区 ──→ git commit ──→ 本地仓库
   ↑                                               |
   └──────────── git checkout/restore ─────────────┘
```

# 基础配置

```bash
# 用户信息
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# 编辑器设置
git config --global core.editor vim           # vim
git config --global core.editor nano          # nano（更简单）
git config --global core.editor "code --wait" # VSCode
```

# 分支操作

## branch

```bash
# 当前分支重命名为 main
git branch -M main
```

## worktree

从同一仓库同时检出多个分支到不同目录。

假如你需要一边在 `main` 上修 `bug`，一边在 `feature` 上开发，如果没有 `worktree` 就需要来回切换分支。

```bash
# 创建一个 worktree，基于 main 分支，放到 ../hotfix 目录
git worktree add ../hotfix main

# 创建一个 worktree 并新建分支
git worktree add -b feature-x ../feature-x main

# 列出所有 worktree
git worktree list

# 用完后删除
git worktree remove ../hotfix
```

与 `git clone` 相比：使用同一个仓库，分支/提交互通，磁盘占用相对较小（共享对象）

与 `git switch` 相比：`git switch` 切换分支时工作区会被完全替换，如果有未提交的改动可能丢失或冲突

# 远程协作

## 关联远程仓库

```bash
git remote add origin https://github.com/0x3ea/xxx.git
```

## 同步

本地一个目录下只能有一个仓库（.git）。**一个本地仓库** 可以绑定 **多个远程地址**。

比如你 fork 了一个项目（origin），开发了自己版本，上传到 GitHub。当上游仓库（upstream）有更新时，你需要同步到本地。

```bash
git fetch              # fetch 所有远程
git fetch origin       # 只 fetch origin
git log                # 查看当前分支的所有历史
git log origin/main    # 查看远程 main 分支的所有历史
git log --oneline      # 当前分支所有历史（一行一条）
git log --all          # 所有分支的历史
git log --decorate     # 显示分支名、标签名等引用信息
git log --graph        # 用 ASCII 字符画出分支合并图
git pull origin/main   # git fetch origin/main + git merge origin/main
# 注意 merge 的时候要让本地和远程分支对应
```

## stash

git stash 把你当前未提交的更改（工作区和暂存区）临时藏起来，让工作区恢复到干净状态。这样你就可以安全地 git pull 拉取远程更新。git stash pop 再把之前藏起来的更改恢复回来。

简单说就是：临时保存你的改动，腾出空间来拉代码

```bash
git stash list    # 查看 stash
git stash drop    # 丢弃最顶部的一条
git stash clear   # 清空所有 stash
```

## blame

追溯指定文件每行代码的修改记录

```bash
git blame filename             # 查看文件每行的最后一次修改是在哪次提交
git blame -L n1,n2 filename    # 文件在 n1,n2 行内的最后一次修改
git blame -L 10,20 filename    # 查看第 10 到 20 行
git blame -C filename          # 检测代码移动/复制
git blame -M filename          # 检测行内移动
```

git blame 的显示格式为
```
commit ID  (代码提交作者  提交时间  代码位于文件中的行数)  实际代码
1a2b3c4d (张三 2024-01-15 10:30:25 1) func main() {
5e6f7g8h (李四 2024-01-16 14:20:10 2)     println("hello")
```

# 回退操作

## 修改 + 未提交

`git checkout -- .` 或 `git restore .`

## 新建 + 未提交

`git checkout -- .` 或 `git clean -fd`

`-f` = force（强制），`-d` = 包含目录

最好先通过 `git clean -dn` 或 `git clean --dry-run` 来查看会删除哪些

## 已提交

### reset

```
原始历史:  A --- B --- C --- D (HEAD)
           ↑
         回到这里

--soft:   B/C/D 的改动 → 暂存区（git commit 可重新提交）
--mixed:  B/C/D 的改动 → 工作区（需 git add 再提交）
--hard:   B/C/D 完全消失，工作区也回到 A 状态
```

| 模式            | A 之后的 commit  | 工作区/暂存区变化     |
| ------------- | ---------------- | ------------- |
| `--soft`      | **保留在暂存区**       | 工作区不变，改动全进暂存区 |
| `--mixed`（默认） | **保留在工作区**       | 工作区不变，改动不暂存   |
| `--hard`      | **彻底丢弃**（有风险）    | 工作区强制回退到 A 状态 |

### revert

用一次新的提交来撤销某次（或某几次）旧提交的改动

# 修改历史

`filter-branch` 会遍历所有 `commit`，对每一个 `commit` 用提供的命令重新构建 index，然后生成一个新的 `commit` 对象。

所有涉及 `TODO.md` 的 `commit` 都被重写为不包含此文件的新 `commit`，旧的 `commit` 对象仍然存在于本地（在 refs/original/ 下），但不再被任何分支引用

注意：所有 `commit hash` 都变了

```bash
git filter-branch --force \
  --index-filter 'git rm --cached --ignore-unmatch TODO.md' \
  --prune-empty -- --all
```

> **注意**：`filter-branch` 已被 Git 官方废弃，推荐使用 [git-filter-repo](https://github.com/newren/git-filter-repo)。

# 发布管理

## release

Git tag + 元数据（描述、二进制附件）

- Tag：指向某个具体的 commit，不可变
- Release：tag 上的一层包装，包含标题、描述、附件
- 二进制附件：Release 独有，不属于 Git

### 查看现有 release 和 tag

```bash
gh release list          # 列出所有 release
git tag -l               # 列出所有 tag
```

### 删除旧 release 和 tag

```bash
gh release delete v0.1.0 --yes          # 删除 GitHub 上的 release
git push origin --delete v0.1.0         # 删除远程 tag
git tag -d v0.1.0                       # 删除本地 tag（如果有）
```

### 添加 release 和 tag

```bash
git tag v0.2.0     # 给当前 HEAD（最新 commit）打上 v0.2.0 标签
git push origin v0.2.0
gh release create v0.2.0 --title "v0.2.0" --notes "配置路径改用系统标准目录" ./build/*
```

## 语义化版本

版本号格式是 `vMAJOR.MINOR.PATCH`，遵循[语义化版本](https://semver.org/)

- `MAJOR`（主版本号） — 不兼容的 API 变更
- `MINOR`（次版本号）— 向后兼容的新功能
- `PATCH`（修订号） — 向后兼容的 bug 修复
