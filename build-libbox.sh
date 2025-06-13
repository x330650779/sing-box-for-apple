#!/bin/bash
set -e

echo "🔧 安装 gomobile..."
go install golang.org/x/mobile/cmd/gomobile@latest
export PATH="$PATH:$(go env GOPATH)/bin"
gomobile init

echo "📦 克隆 sing-box 并初始化模块..."
rm -rf sing-box
git clone --depth=1 https://github.com/SagerNet/sing-box.git
cd sing-box

echo "🔧 拉取依赖（使用 sing-box 主仓的 go.mod）..."
go mod tidy

echo "📦 进入 libbox 模块目录..."
cd experimental/libbox

echo "⚙️ 构建各平台 .framework（非 .xcframework）..."
gomobile bind -tags with_utls -target=ios/arm64 -o libbox_ios_arm64.framework .
gomobile bind -tags with_utls -target=iossimulator/arm64 -o libbox_iossim_arm64.framework .
gomobile bind -tags with_utls -target=macos/arm64 -o libbox_macos_arm64.framework .

echo "📦 打包产物..."
cd ..
zip -r libbox_artifacts.zip libbox/*.framework

echo "✅ 构建完成，产物位置：sing-box/experimental/libbox/*.framework 和 libbox_artifacts.zip"
