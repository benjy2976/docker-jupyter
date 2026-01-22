#!/usr/bin/env bash
set -euo pipefail

export DISPLAY="${DISPLAY:-:0}"

# Start X virtual framebuffer + lightweight WM
Xvfb "${DISPLAY}" -screen 0 1280x800x24 -ac +extension RANDR &
fluxbox &

# Start VNC server
x11vnc -display "${DISPLAY}" -forever -shared -rfbport 5900 -nopw &

# Start noVNC (websockify)
if command -v novnc_proxy >/dev/null 2>&1; then
  novnc_proxy --vnc localhost:5900 --listen 6080 &
elif [ -x /usr/share/novnc/utils/novnc_proxy ]; then
  /usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &
elif command -v websockify >/dev/null 2>&1 && [ -d /usr/share/novnc ]; then
  websockify --web /usr/share/novnc 6080 localhost:5900 &
fi

exec "$@"
