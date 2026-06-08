#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: scripts/package.sh <version> (e.g. 0.2.0)}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="WarpLocal"
OUTPUT_DMG="${REPO_ROOT}/target/release/WarpLocal-v${VERSION}.dmg"

echo "==> Building aarch64..."
cd "$REPO_ROOT"
MACOSX_DEPLOYMENT_TARGET=14.0 cargo build --release -p warp --bin warplocal --target aarch64-apple-darwin

echo "==> Building x86_64..."
MACOSX_DEPLOYMENT_TARGET=14.0 cargo build --release -p warp --bin warplocal --target x86_64-apple-darwin

echo "==> Creating universal binary..."
mkdir -p "${REPO_ROOT}/target/release/universal"
lipo -create \
  "${REPO_ROOT}/target/aarch64-apple-darwin/release/warplocal" \
  "${REPO_ROOT}/target/x86_64-apple-darwin/release/warplocal" \
  -output "${REPO_ROOT}/target/release/universal/warplocal"
chmod +x "${REPO_ROOT}/target/release/universal/warplocal"
lipo -info "${REPO_ROOT}/target/release/universal/warplocal"

echo "==> Creating .app bundle..."
BUNDLE_DIR="${REPO_ROOT}/target/release/${APP_NAME}.app/Contents"
rm -rf "${REPO_ROOT}/target/release/${APP_NAME}.app"
mkdir -p "${BUNDLE_DIR}/MacOS" "${BUNDLE_DIR}/Resources"
cp "${REPO_ROOT}/target/release/universal/warplocal" "${BUNDLE_DIR}/MacOS/"

if [ -d "${REPO_ROOT}/target/aarch64-apple-darwin/release/WarpDockTilePlugin.docktileplugin" ]; then
    cp -R "${REPO_ROOT}/target/aarch64-apple-darwin/release/WarpDockTilePlugin.docktileplugin" "${BUNDLE_DIR}/Resources/"
fi

echo "==> Creating DMG..."
rm -f "$OUTPUT_DMG"
hdiutil create \
    -volname "$APP_NAME" \
    -srcfolder "${REPO_ROOT}/target/release/${APP_NAME}.app" \
    -ov \
    -format UDZO \
    "$OUTPUT_DMG"

echo "==> Done: $OUTPUT_DMG"
ls -lh "$OUTPUT_DMG"
