#!/bin/bash
set -e

echo "🔧 安装 gomobile..."
go install golang.org/x/mobile/cmd/gomobile@latest
export PATH="$PATH:$(go env GOPATH)/bin"
gomobile init

echo "📦 克隆 sing-box 并进入 libbox 模块目录..."
rm -rf sing-box
git clone --depth=1 https://github.com/SagerNet/sing-box.git
cd sing-box/experimental/libbox

echo "🔧 初始化 go.mod & 拉取依赖..."
go mod init github.com/sagernet/libbox
go mod tidy

echo "⚙️ 构建各平台 .framework（非 .xcframework）..."

# ✅ 生成 ios 真机版本
gomobile bind -tags with_utls -target=ios/arm64 -o libbox_ios_arm64.framework .

# ✅ 生成 iOS 模拟器版本
gomobile bind -tags with_utls -target=iossimulator/arm64 -o libbox_iossim_arm64.framework .

# ✅ 生成 macOS Apple Silicon 版本
gomobile bind -tags with_utls -target=macos/arm64 -o libbox_macos_arm64.framework .

echo "📦 打包产物..."
cd ..
zip -r libbox_artifacts.zip libbox/*.framework

echo "✅ 构建完成，产物位置：sing-box/experimental/libbox/*.framework 和 libbox_artifacts.zip"
