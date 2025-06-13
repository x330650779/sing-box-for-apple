#!/bin/bash
set -e

echo "🔧 安装 gomobile..."
go install golang.org/x/mobile/cmd/gomobile@latest
export PATH="$PATH:$(go env GOPATH)/bin"
gomobile init

echo "📆 克隆 sing-box 并初始化模块..."
rm -rf sing-box
git clone --depth=1 https://github.com/SagerNet/sing-box.git
cd sing-box

echo "🔧 拉取依赖..."
go mod tidy

cd experimental/libbox

echo "⚙️ 构建各平台 .xcframework..."
gomobile bind -tags with_utls -target=ios/arm64 -o libbox_ios_arm64.xcframework .
gomobile bind -tags with_utls -target=iossimulator/arm64 -o libbox_iossim_arm64.xcframework .
gomobile bind -tags with_utls -target=macos/arm64 -o libbox_macos_arm64.xcframework .

echo "✅ 构建完成，产物路径如下："
ls -lh *.xcframework
