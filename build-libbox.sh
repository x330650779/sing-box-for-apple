#!/bin/bash
set -e

echo "🔧 安装 gomobile..."
go install golang.org/x/mobile/cmd/gomobile@latest
export PATH="$PATH:$(go env GOPATH)/bin"
gomobile init

echo "📥 拉取 gomobile 所需子模块..."
go get golang.org/x/mobile/bind

echo "📦 克隆 sing-box 并进入 libbox 模块目录..."
rm -rf sing-box
git clone --depth=1 https://github.com/SagerNet/sing-box.git
cd sing-box/experimental/libbox

echo "🔧 初始化 go.mod 和 go.sum..."
go mod tidy

echo "⚙️ 构建为各平台架构..."
gomobile bind -tags with_utls -target=ios/arm64 -o libbox_ios_arm64.xcframework .
gomobile bind -tags with_utls -target=iossimulator/arm64 -o libbox_iossim_arm64.xcframework .
gomobile bind -tags with_utls -target=macos/arm64 -o libbox_macos_arm64.xcframework .

echo "🧩 合并为 Libbox.xcframework..."
xcodebuild -create-xcframework \
  -framework libbox_ios_arm64.xcframework \
  -framework libbox_iossim_arm64.xcframework \
  -framework libbox_macos_arm64.xcframework \
  -output Libbox.xcframework
