#!/bin/bash
# Hugo 博客部署脚本 - 部署到 GitHub Pages

set -e

echo "🔨 开始构建..."
hugo --minify

echo "📂 切换到 gh-pages 分支..."
git checkout gh-pages

echo "🧹 清空旧文件..."
git rm -rf . || true

echo "📋 复制构建产物..."
cp -r public/* .
rm -rf public

echo "💾 提交更改..."
git add -A
git commit -m "Deploy $(date '+%Y-%m-%d %H:%M:%S')"

echo "🚀 推送到 GitHub..."
git push origin gh-pages

echo "🔙 切回 main 分支..."
git checkout main

echo "✅ 部署完成!"
echo "🌐 访问 https://0x3ea.github.io/blog/"
