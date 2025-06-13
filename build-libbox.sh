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
go mod tidy

echo "⚙️ 绑定生成各平台伪装为 .xcframework 的 framework..."
gomobile bind -tags with_utls -target=ios/arm64 -o libbox_ios_arm64.xcframework .
gomobile bind -tags with_utls -target=iossimulator/arm64 -o libbox_iossim_arm64.xcframework .
gomobile bind -tags with_utls -target=macos/arm64 -o libbox_macos_arm64.xcframework .

echo "🧩 合并为真正的 Libbox.xcframework..."
xcodebuild -create-xcframework \
  -framework libbox_ios_arm64.xcframework \
  -framework libbox_iossim_arm64.xcframework \
  -framework libbox_macos_arm64.xcframework \
  -output Libbox.xcframework

echo "✅ 构建完成：sing-box/experimental/libbox/Libbox.xcframework"
