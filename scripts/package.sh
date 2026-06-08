#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Usage: scripts/package.sh <version> (e.g. 0.1.0)}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="WarpLocal"
BUNDLE_ID="dev.warp.WarpLocal"
OUTPUT_DMG="${REPO_ROOT}/target/release/WarpLocal-v${VERSION}-aarch64.dmg"

echo "==> Building release binary..."
cd "$REPO_ROOT"
MACOSX_DEPLOYMENT_TARGET=14.0 cargo build --release -p warp --bin warplocal

echo "==> Creating .app bundle..."
BUNDLE_DIR="${REPO_ROOT}/target/release/${APP_NAME}.app/Contents"
rm -rf "${REPO_ROOT}/target/release/${APP_NAME}.app"
mkdir -p "${BUNDLE_DIR}/MacOS" "${BUNDLE_DIR}/Resources"
cp "${REPO_ROOT}/target/release/warplocal" "${BUNDLE_DIR}/MacOS/"
chmod +x "${BUNDLE_DIR}/MacOS/warplocal"

if [ -d "${REPO_ROOT}/target/release/WarpDockTilePlugin.docktileplugin" ]; then
    cp -R "${REPO_ROOT}/target/release/WarpDockTilePlugin.docktileplugin" "${BUNDLE_DIR}/Resources/"
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
