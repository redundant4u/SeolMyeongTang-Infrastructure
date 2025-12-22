#!/bin/sh

set -e

: "${USER_NAME:=app}"
: "${USER_PASSWORD:=app}"

useradd -m -s /bin/bash "$USER_NAME"
echo "$USER_NAME:$USER_PASSWORD" | chpasswd
usermod -aG sudo "$USER_NAME"

# mkdir -p /var/lib/dbus
# if [ ! -f /var/lib/dbus/machine-id ]; then
#     dbus-uuidgen > /var/lib/dbus/machine-id
#     ln -sf /var/lib/dbus/machine-id /etc/machine-id
# fi

# DBus 런타임 디렉토리 생성
# '/run/dbus' 디렉토리가 없으면 소켓을 만들지 못해 에러가 발생합니다.
mkdir -p /run/dbus
dbus-daemon --system --fork

# locale 설정
locale-gen en_US.UTF-8

# VNC 설정 디렉토리 준비
mkdir -p /home/$USER_NAME/.vnc
cp /xstartup /home/$USER_NAME/.vnc/xstartup

# 바탕화면 바로가기(심볼릭 링크) 생성
DESKTOP_DIR="/home/${USER_NAME}/Desktop"
mkdir -p "${DESKTOP_DIR}"

cat > "${DESKTOP_DIR}/Terminal.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Terminal
Comment=Open a terminal window
Exec=gnome-terminal
Icon=utilities-terminal
Terminal=false
Categories=System;Utility;TerminalEmulator;
EOF

cat > "${DESKTOP_DIR}/firefox.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox Web Browser
Comment=Browse the Web
Exec=/usr/bin/firefox %u
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Terminal=false
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
EOF

# 권한 문제 방지를 위해 홈 디렉토리 소유권 재확인
chown -R "$USER_NAME:$USER_NAME" /home/$USER_NAME

exec runuser -u "$USER_NAME" -- /vncserver.sh
