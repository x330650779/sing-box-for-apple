#!/bin/bash
set -e

echo "🔧 安装 gomobile 和 gobind..."
go install golang.org/x/mobile/cmd/gomobile@latest
go install golang.org/x/mobile/cmd/gobind@latest
export PATH="$PATH:$(go env GOPATH)/bin"

echo "📦 初始化 gomobile..."
gomobile init

echo "📦 克隆 sing-box 并进入 libbox 模块目录..."
rm -rf sing-box
git clone --depth=1 https://github.com/SagerNet/sing-box.git
cd sing-box/experimental/libbox

echo "🔧 初始化 go.mod 和依赖..."
go mod init github.com/sagernet/libbox || true
go mod tidy

# 手动拉取 mobile bind 模块，防止找不到
echo "📥 拉取 golang.org/x/mobile 依赖..."
go get golang.org/x/mobile/bind
go mod tidy

echo "⚙️ 使用 gomobile 构建各平台版本（输出为 .xcframework）..."
gomobile bind -tags with_utls -target=ios/arm64 -o libbox_ios_arm64.xcframework .
gomobile bind -tags with_utls -target=iossimulator/arm64 -o libbox_iossim_arm64.xcframework .
gomobile bind -tags with_utls -target=macos/arm64 -o libbox_macos_arm64.xcframework .

echo "✅ 所有 .xcframework 构建完成。产物列表："
ls -lh *.xcframework
