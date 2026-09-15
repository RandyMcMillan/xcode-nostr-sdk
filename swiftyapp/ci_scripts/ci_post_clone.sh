#!/bin/sh
set -e

# Install Rust if not present (Xcode Cloud runners don't have it by default)
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# shellcheck disable=SC1090
source "$HOME/.cargo/env" 2>/dev/null || true

# Add iOS/macOS targets
rustup target add aarch64-apple-ios
rustup target add aarch64-apple-ios-sim
rustup target add aarch64-apple-darwin

# Build Rust xcframework so real binaries exist before Xcode processes the project
cd "$CI_WORKSPACE"
./build.sh

echo "Rust installed and xcframework built."
