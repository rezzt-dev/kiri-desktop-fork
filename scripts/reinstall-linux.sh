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
PREFERRED_DIR=/mnt/datos/-programs/kiri   # used when it exists
DEFAULT_DIR=/usr/local/bin
UNIT=/etc/systemd/system/kiri.service
SOCKET=/run/kiri/docker.sock
LOG="$(mktemp -t kiri-reinstall.XXXXXX.log)"

if [ -d "$PREFERRED_DIR" ]; then BIN_DIR="$PREFERRED_DIR"; else BIN_DIR="$DEFAULT_DIR"; fi

case "$(uname -m)" in
  x86_64)  ARCH=amd64; OUT=linux-x86_64 ;;
  aarch64) ARCH=arm64; OUT=linux ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac
NEW="$ROOT/target/$OUT/release"
# The window (`kiri ui`) is a separate glibc build linked to GTK 3 and
# WebKitGTK 4.1; `kiri` looks for it at this fixed path.
WIN_BIN="$ROOT/target/window/release/kiri"
WIN_LINK=/usr/lib/kiri/kiri-window
HAS_WINDOW=0
if [ "$ARCH" = amd64 ] && command -v cargo >/dev/null && pkg-config --exists gtk+-3.0 webkit2gtk-4.1 2>/dev/null; then HAS_WINDOW=1; fi

# ---- look & feel -----------------------------------------------------------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  B=$'\e[1m'; D=$'\e[2m'; R=$'\e[31m'; G=$'\e[32m'; C=$'\e[36m'; Z=$'\e[0m'; HIDE=$'\e[?25l'; SHOW=$'\e[?25h'
else
  B=; D=; R=; G=; C=; Z=; HIDE=; SHOW=
fi
trap 'printf "%s" "$SHOW"' EXIT

# step "Label" cmd...   runs cmd quietly with a spinner; output goes to $LOG
step() {
  local label="$1"; shift
  local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏' i=0 pid rc=0
  if [ -t 1 ]; then
    "$@" >>"$LOG" 2>&1 & pid=$!
    printf '%s' "$HIDE"
    while kill -0 "$pid" 2>/dev/null; do
      printf '\r  %s%s%s %s' "$C" "${frames:i++%${#frames}:1}" "$Z" "$label"
      sleep 0.1
    done
    wait "$pid" || rc=$?
    printf '\r\e[K%s' "$SHOW"
  else
    "$@" >>"$LOG" 2>&1 || rc=$?
  fi
  if [ "$rc" -eq 0 ]; then
    printf '  %s✔%s %s\n' "$G" "$Z" "$label"
  else
    printf '  %s✘%s %s\n\n' "$R" "$Z" "$label"
    printf '%s--- last log lines (%s) ---%s\n' "$D" "$LOG" "$Z"
    tail -n 15 "$LOG"
    exit 1
  fi
}

SUDO=""
[ "$(id -u)" -eq 0 ] || SUDO="sudo"

printf '\n%s Kiri · reinstall%s\n' "$B" "$Z"
printf '%s   %s → %s%s\n\n' "$D" "$ARCH" "$BIN_DIR" "$Z"

# Ask for the password once, up front, so the spinner is not interrupted.
[ -z "$SUDO" ] || sudo -v

# ---- steps -----------------------------------------------------------------
build() {
  export DOCKER_HOST="${DOCKER_HOST:-unix://$SOCKET}"
  (cd "$ROOT" && cargo xtask linux --arch "$ARCH")
  [ -x "$NEW/kiri" ] && [ -x "$NEW/kiri-init" ]
}

build_window() {
  (cd "$ROOT" && CARGO_TARGET_DIR="$ROOT/target/window" cargo build --release -p kiri --features window)
  [ -x "$WIN_BIN" ]
}

remove_old() {
  if [ -d /run/systemd/system ]; then $SUDO systemctl disable --now kiri.service || true; fi
  for d in "$BIN_DIR" "$PREFERRED_DIR" "$DEFAULT_DIR"; do $SUDO rm -f "$d/kiri" "$d/kiri-init" "$d/kiri-window"; done
  $SUDO rm -f "$WIN_LINK" /usr/share/applications/kiri.desktop /usr/share/icons/hicolor/scalable/apps/kiri.svg
  $SUDO rm -f "$UNIT" "$SOCKET"
  $SUDO systemctl daemon-reload || true
}

install_new() {
  $SUDO install -m 0755 "$NEW/kiri" "$NEW/kiri-init" "$BIN_DIR/"
  # kiri finds kiri-init beside itself; point the unit at the chosen directory.
  sed "s|^ExecStart=.*|ExecStart=$BIN_DIR/kiri daemon|" "$ROOT/contrib/linux/kiri.service" | $SUDO tee "$UNIT" >/dev/null
  $SUDO chmod 0644 "$UNIT"
  # Custom install dir: make `kiri` available on PATH.
  if [ "$BIN_DIR" != "$DEFAULT_DIR" ]; then
    $SUDO ln -sf "$BIN_DIR/kiri" "$DEFAULT_DIR/kiri"
  fi
  getent group kiri >/dev/null || $SUDO groupadd -r kiri
  local u="${SUDO_USER:-$USER}"
  if [ "$u" != root ] && ! id -nG "$u" | grep -qw kiri; then
    $SUDO usermod -aG kiri "$u"
    touch "$LOG.relogin"
  fi
}

install_window() {
  $SUDO install -m 0755 "$WIN_BIN" "$BIN_DIR/kiri-window"
  $SUDO install -d /usr/lib/kiri
  $SUDO ln -sf "$BIN_DIR/kiri-window" "$WIN_LINK"
  $SUDO install -D -m 0644 "$ROOT/brand/icon/kiri-app-icon.svg" /usr/share/icons/hicolor/scalable/apps/kiri.svg
  $SUDO install -D -m 0644 "$ROOT/contrib/linux/kiri.desktop" /usr/share/applications/kiri.desktop
  command -v gtk-update-icon-cache >/dev/null && $SUDO gtk-update-icon-cache -q -t /usr/share/icons/hicolor || true
}

start() {
  $SUDO systemctl daemon-reload
  $SUDO systemctl enable --now kiri.service
  for _ in $(seq 1 20); do [ -S "$SOCKET" ] && return 0; sleep 0.5; done
  journalctl -u kiri.service -n 20 --no-pager 2>/dev/null || true
  return 1
}

if [ "${1:-}" = "--skip-build" ]; then
  [ -x "$NEW/kiri" ] && [ -x "$NEW/kiri-init" ] || { printf '  %s✘%s no build in %s\n' "$R" "$Z" "$NEW"; exit 1; }
  printf '  %s–%s Build skipped\n' "$D" "$Z"
else
  step "Building kiri (first run takes a few minutes)" build
fi
if [ "$HAS_WINDOW" = 1 ] && [ "${1:-}" != "--skip-build" ]; then
  step "Building the window (GTK + WebKitGTK)" build_window
fi
step "Removing previous version" remove_old
step "Installing new version"   install_new
if [ "$HAS_WINDOW" = 1 ] && [ -x "$WIN_BIN" ]; then
  step "Installing the window" install_window
else
  printf '  %s–%s No window: needs x86-64, cargo, GTK 3 and WebKitGTK 4.1 dev files\n' "$D" "$Z"
fi
step "Starting the engine"      start

printf '\n  %s%sDone.%s Kiri is listening on %s\n' "$G" "$B" "$Z" "$SOCKET"
if [ -e "$LOG.relogin" ]; then
  printf '  %s!%s You were added to the %skiri%s group: log out and back in once.\n' "$C" "$Z" "$B" "$Z"
  rm -f "$LOG.relogin"
fi
printf '  %sLog: %s%s\n\n' "$D" "$LOG" "$Z"
