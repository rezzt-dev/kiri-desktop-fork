#!/usr/bin/env bash
# Rebuilds Kiri for this Linux host and replaces the installed version.
#
# Order matters: the build runs in a Docker container, and DOCKER_HOST may
# point at the Kiri engine itself (unix:///run/kiri/docker.sock), so the old
# engine is only stopped and removed once the new binaries exist.
#
# Usage: scripts/reinstall-linux.sh [--skip-build]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR=/usr/local/bin
UNIT=/etc/systemd/system/kiri.service
SOCKET=/run/kiri/docker.sock

case "$(uname -m)" in
  x86_64)  ARCH=amd64; OUT=linux-x86_64 ;;
  aarch64) ARCH=arm64; OUT=linux ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac
NEW="$ROOT/target/$OUT/release"

SUDO=""
[ "$(id -u)" -eq 0 ] || SUDO="sudo"

# 1. Build (old engine, if any, is still running for Docker's sake).
if [ "${1:-}" != "--skip-build" ]; then
  echo "==> Building kiri and kiri-init ($ARCH)"
  export DOCKER_HOST="${DOCKER_HOST:-unix://$SOCKET}"
  (cd "$ROOT" && cargo xtask linux --arch "$ARCH")
fi
for b in kiri kiri-init; do
  [ -x "$NEW/$b" ] || { echo "missing $NEW/$b (build failed?)" >&2; exit 1; }
done

# 2. Remove the previous version.
echo "==> Removing previous version"
if command -v systemctl >/dev/null && [ -d /run/systemd/system ]; then
  $SUDO systemctl disable --now kiri.service 2>/dev/null || true
fi
$SUDO rm -f "$UNIT" "$BIN_DIR/kiri" "$BIN_DIR/kiri-init"
$SUDO rm -f "$SOCKET"
command -v systemctl >/dev/null && $SUDO systemctl daemon-reload 2>/dev/null || true

# 3. Install the new one.
echo "==> Installing new version"
$SUDO install -m 0755 "$NEW/kiri" "$NEW/kiri-init" "$BIN_DIR/"
$SUDO install -m 0644 "$ROOT/contrib/linux/kiri.service" "$UNIT"
getent group kiri >/dev/null || $SUDO groupadd -r kiri
TARGET_USER="${SUDO_USER:-$USER}"
if [ "$TARGET_USER" != root ] && ! id -nG "$TARGET_USER" | grep -qw kiri; then
  $SUDO usermod -aG kiri "$TARGET_USER"
  echo "    $TARGET_USER added to group kiri: log out and back in once."
fi

$SUDO systemctl daemon-reload
$SUDO systemctl enable --now kiri.service

# 4. Check it came up.
for _ in $(seq 1 20); do [ -S "$SOCKET" ] && break; sleep 0.5; done
if [ -S "$SOCKET" ]; then
  echo "==> Kiri is running on $SOCKET"
else
  echo "Kiri did not create $SOCKET; see: journalctl -u kiri.service" >&2
  exit 1
fi
