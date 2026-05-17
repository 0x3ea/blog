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
# submodule

如果项目需要其他仓库,可以使用 `submodule` 来管理

父仓库的 `commit` 直接指向子模块仓库的一个特定 `commit`
```shell
git submodule add <Remote URL> Target Path
```
`commit/push` 都需要先子模块,再父仓库

# 分支操作

## 特殊引用

引用	含义	更新时机
HEAD	当前分支的当前位置	每次都更新
ORIG_HEAD	危险操作前 HEAD 的位置	merge/rebase/reset/pull 时
FETCH_HEAD	最近 fetch 的分支信息	git fetch 时
MERGE_HEAD	正在合并的另一个分支	git merge 时
REBASE_HEAD	rebase 正在进行的提交	git rebase 时

查看这些引用

```shell
git show ORIG_HEAD --oneline
```

## branch

```bash
# 创建名为 main 的分支
git branch main
# 当前分支重命名为 main
git branch -M main
# 查看该仓库的所有分支
git branch --all
# 删除分支
git branch -d main
# 查看分支跟踪的远程分支
git branch -vv
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

与 `git clone` 相比：使用同一个仓库，分支/提交互通，磁盘占用相对较小（共享对象）。

与 `git switch` 相比：`git switch` 会在同一个工作区切换分支；如果未提交改动与目标分支冲突，Git 会拒绝切换，需要先提交、stash 或清理。

# 远程协作

## 关联远程仓库

```bash
# 关联远程仓库
git remote add origin https://github.com/0x3ea/xxx.git
# 查看当前关联仓库
git remote -v
# 重新关联origin
git remote set-url origin git@github.com:private/repo.git
```
## 上传

把本地仓库的所有分支上传到远程仓库,并创建 `upstream`
```bash
git push -u origin --all
```

## upstream/tracking

本地分支默认对应的远程分支

比如本地有一个 `main` 分支,远程有一个 `origin/main` 分支

如果本地 `main` 设置了 `upstream` 为 `origin/main``，Git` 就知道当前本地 `main` 默认是和远程的 `origin/main` 对应的。

这样在 `main` 分支上就可以直接运行：

```bash
git pull
git push
```
而不用每次都写：
```bash
git pull origin main
git push origin main
```
本地分支设置 `upstream` 后,它就 `tracking` 某个远程分支


## 同步

本地一个目录下只能有一个仓库（.git）。**一个本地仓库** 可以绑定 **多个远程地址**。

比如你 fork 了一个项目（origin），开发了自己版本，上传到 GitHub。当上游仓库（upstream）有更新时，你需要同步到本地。

```bash
git fetch --all          # fetch 所有远程
git fetch origin         # fetch origin 的所有分支
git fetch origin main    # fetch origin 的 main 分支
git log                  # 查看当前分支的所有历史
git log origin/main      # 查看远程 main 分支的所有历史
git log --oneline        # 当前分支所有历史（一行一条）
git log --all            # 所有分支的历史
git log --decorate       # 显示分支名、标签名等引用信息
git log --graph          # 用 ASCII 字符画出分支合并图
git pull origin main     # fetch origin main 后合并到当前分支
git merge origin/main    # 合并远程跟踪分支 origin/main
# 注意 merge 的时候要让本地和远程分支对应
```

同步分支
```bash
# 把 commit 同步到当前分支
git cherry-pick f9437d4
```

## stash

Git stash 把当前未提交的更改（工作区和暂存区）临时藏起来，让工作区恢复到干净状态。这样就可以安全地 `git pull` 拉取远程更新，再用 `git stash pop` 恢复之前藏起来的更改。

默认 `git stash` 不包含未跟踪文件；如需包含未跟踪文件，使用 `git stash -u`。

简单说就是：临时保存你的改动，腾出空间来拉代码。

```bash
git stash         # 保存当前改动
git stash -u      # 保存当前改动，包括未跟踪文件
git stash list    # 查看 stash
git stash pop     # 恢复最近一次 stash，并删除该 stash
git stash apply   # 恢复 stash，但保留 stash 记录
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

使用 `git clean -fd` 删除未跟踪文件和目录。

`-f` = force（强制），`-d` = 包含目录。

最好先通过 `git clean -dn` 或 `git clean --dry-run` 查看会删除哪些文件。

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

| 模式            | A 之后的改动       | 工作区/暂存区变化     |
| ------------- | ---------------- | ------------- |
| `--soft`      | **保留在暂存区**       | 工作区不变，改动全进暂存区 |
| `--mixed`（默认） | **保留在工作区**       | 工作区不变，改动不暂存   |
| `--hard`      | **彻底丢弃**（有风险）    | 工作区强制回退到 A 状态 |

### revert

用一次新的提交来撤销某次（或某几次）旧提交的改动。

# 修改历史

## 修改commit message

修改最近一次提交
```shell
git commit --amend -m "new commit message"
```

## 删除历史中的敏感文件

如果误提交了密钥、大文件或不应进入仓库的文件，可以重写历史。

`filter-branch` 会遍历所有 `commit`，对每一个 `commit` 用提供的命令重新构建 index，然后生成一个新的 `commit` 对象。

所有涉及 `TODO.md` 的 `commit` 都被重写为不包含此文件的新 `commit`，旧的 `commit` 对象仍然存在于本地（在 refs/original/ 下），但不再被任何分支引用。

注意：所有 `commit hash` 都会变化。如果这些提交已经推送到远程仓库，重写历史会影响协作者。

```bash
git filter-branch --force \
  --index-filter 'git rm --cached --ignore-unmatch TODO.md' \
  --prune-empty -- --all
```

> **注意**：`filter-branch` 已被 Git 官方废弃，推荐使用 [git-filter-repo](https://github.com/newren/git-filter-repo)。

## rebase

当远程有了新的提交，本地也有提交时，Git 会拒绝 push，因为当前分支落后于远程，需要先同步。

`git rebase origin main` 将当前分支的提交，以远程仓库的 origin/main 分支（本地存储的远程跟踪分支）作为新的基底，重新应用

```bash
git pull --rebase origin main
# 跟上面等效
git fetch origin main
git rebase origin/main
```

# 发布管理

## release

Git tag + 元数据（描述、二进制附件）。

- Tag：指向某个具体的 commit，发布后不应修改
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

版本号格式是 `vMAJOR.MINOR.PATCH`，遵循 [语义化版本](https://semver.org/)。

- `MAJOR`（主版本号） — 不兼容的 API 变更
- `MINOR`（次版本号） — 向后兼容的新功能
- `PATCH`（修订号） — 向后兼容的 bug 修复
