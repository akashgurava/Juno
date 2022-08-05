#!/bin/bash

set -e

THISDIR=$(dirname $0)
cd $THISDIR

export SWIFT_BRIDGE_OUT_DIR="$(pwd)/generated"

# Build the project for the desired platforms:
# iOS
cargo build --target aarch64-apple-ios

# iOS Simulators
cargo build --target x86_64-apple-ios
cargo build --target aarch64-apple-ios-sim

# MacOS
cargo build --target x86_64-apple-darwin
cargo build --target aarch64-apple-darwin

# Make Universal folders
mkdir -p ./target/universal-ios-sim/debug
mkdir -p ./target/universal-macos/debug

# Stitch iOS Simulators
lipo \
    ./target/aarch64-apple-ios-sim/debug/libjuno_rust.a \
    ./target/x86_64-apple-ios/debug/libjuno_rust.a -create -output \
    ./target/universal-ios-sim/debug/libjuno_rust.a

# Stitch MacOS
lipo \
    ./target/aarch64-apple-darwin/debug/libjuno_rust.a \
    ./target/x86_64-apple-darwin/debug/libjuno_rust.a -create -output \
    ./target/universal-macos/debug/libjuno_rust.a

# Make Binary
rm -rf JunoRust
swift-bridge-cli create-package \
  --bridges-dir ./generated \
  --out-dir JunoRust \
  --ios target/aarch64-apple-ios/debug/libjuno_rust.a \
  --simulator target/universal-ios-sim/debug/libjuno_rust.a \
  --macos target/universal-macos/debug/libjuno_rust.a \
  --name JunoRust

