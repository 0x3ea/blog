#!/bin/bash
# Hugo 博客部署脚本 - 使用 worktree 部署到 GitHub Pages

set -e

BRANCH=gh-pages
DEPLOY_DIR=.deploy

echo "🔨 开始构建..."
hugo --minify

echo "📂 准备部署目录..."
# 如果 worktree 已存在，先移除
if [ -d "$DEPLOY_DIR" ]; then
    git worktree remove "$DEPLOY_DIR" --force 2>/dev/null || rm -rf "$DEPLOY_DIR"
fi
git worktree add "$DEPLOY_DIR" "$BRANCH"

echo "🧹 清空旧文件..."
cd "$DEPLOY_DIR"
git rm -rf . 2>/dev/null || true

echo "📋 复制构建产物..."
cp -r ../public/* .

echo "💾 提交更改..."
git add -A
if ! git diff --cached --quiet; then
    git commit -m "Deploy $(date '+%Y-%m-%d %H:%M:%S')"
    echo "🚀 推送到 GitHub..."
    if ! git push origin "$BRANCH"; then
        echo "❌ 推送失败！回滚 commit..."
        git reset HEAD~1
        exit 1
    fi
else
    echo "⏭️  无内容变更，跳过部署"
    cd ..
    git worktree remove "$DEPLOY_DIR" --force
    rm -rf public
    exit 0
fi

echo "🔙 清理..."
cd ..
git worktree remove "$DEPLOY_DIR" --force
rm -rf public

echo "📦 同步 main 分支..."
if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    git add -A
    git commit -m "Update source $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main
    echo "✅ 源文件已同步到 main"
else
    echo "⏭️  main 无变更，跳过"
fi

echo "✅ 部署完成!"
echo "🌐 访问 https://0x3ea.github.io/blog/"
