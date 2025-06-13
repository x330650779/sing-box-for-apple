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

echo "🔧 初始化 go.mod & 依赖..."
go mod tidy
go get golang.org/x/mobile/bind

echo "⚙️ 使用 gomobile 构建各平台版本（生成 .framework 文件夹）..."
gomobile bind -tags with_utls -target=ios/arm64 -o libbox_ios_arm64.framework -framework .
gomobile bind -tags with_utls -target=iossimulator/arm64 -o libbox_iossim_arm64.framework -framework .
gomobile bind -tags with_utls -target=macos/arm64 -o libbox_macos_arm64.framework -framework .

echo "📦 手动产出完成，请从以下路径取出 .framework："
echo " - sing-box/experimental/libbox/libbox_ios_arm64.framework"
echo " - sing-box/experimental/libbox/libbox_iossim_arm64.framework"
echo " - sing-box/experimental/libbox/libbox_macos_arm64.framework"
