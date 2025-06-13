#!/bin/bash
set -e
# 安装 gomobile
go install golang.org/x/mobile/cmd/gomobile@latest
export PATH="$PATH:$(go env GOPATH)/bin"
gomobile init

cd sing-box/experimental/libbox
go mod tidy

# 针对三个平台分别构建 .framework
gomobile bind -tags with_utls -target=ios/arm64 -o libbox_ios_arm64.framework .
gomobile bind -tags with_utls -target=iossimulator/arm64 -o libbox_iossim_arm64.framework .
gomobile bind -tags with_utls -target=macos/arm64 -o libbox_macos_arm64.framework .

xcodebuild -create-xcframework \
  -framework libbox_ios_arm64.framework \
  -framework libbox_iossim_arm64.framework \
  -framework libbox_macos_arm64.framework \
  -output Libbox.xcframework
