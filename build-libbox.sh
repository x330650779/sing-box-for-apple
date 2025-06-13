#!/bin/bash
set -e

echo "🔧 安装 gomobile..."
go install golang.org/x/mobile/cmd/gomobile@latest
export PATH="$PATH:$(go env GOPATH)/bin"
gomobile init

echo "📦 克隆 sing-box 仓库..."
rm -rf sing-box
git clone --depth=1 https://github.com/SagerNet/sing-box.git
cd sing-box/experimental/libbox

echo "🔧 初始化 go.mod 和依赖..."
go mod tidy
go get golang.org/x/mobile/bind

echo "⚙️ 编译各平台架构 framework..."
gomobile bind -tags with_utls -target=ios/arm64 -o libbox_ios_arm64.framework .
gomobile bind -tags with_utls -target=iossimulator/arm64 -o libbox_iossim_arm64.framework .
gomobile bind -tags with_utls -target=macos/arm64 -o libbox_macos_arm64.framework .

echo "🧩 合并为单一 xcframework..."
xcodebuild -create-xcframework \
  -framework libbox_ios_arm64.framework \
  -framework libbox_iossim_arm64.framework \
  -framework libbox_macos_arm64.framework \
  -output Libbox.xcframework

echo "✅ 构建完成，路径：$(pwd)/Libbox.xcframework"
