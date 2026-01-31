#!/bin/sh

set -e

: "${USER_NAME:=app}"
: "${USER_PASSWORD:=app}"

useradd -m -s /bin/bash ${USER_NAME}

usermod -aG sudo ${USER_NAME}
echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd
unset USER_PASSWORD

mkdir -p /home/$USER_NAME/.vnc
cp /xstartup /home/$USER_NAME/.vnc/xstartup
chmod +x /home/$USER_NAME/.vnc/xstartup
chown -R "$USER_NAME:$USER_NAME" /home/$USER_NAME/.vnc

# firefox 바로가기
DESKTOP_DIR="/home/${USER_NAME}/Desktop"
mkdir -p "${DESKTOP_DIR}"

cat > "${DESKTOP_DIR}/firefox.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox ESR
Comment=Browse the Web
Exec=/usr/bin/firefox-esr %u
Icon=firefox-esr
Terminal=false
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
EOF

chmod +x "${DESKTOP_DIR}/firefox.desktop"
chown ${USER_NAME}:${USER_NAME} "${DESKTOP_DIR}/firefox.desktop"

exec runuser -u ${USER_NAME} -- /vncserver.sh
