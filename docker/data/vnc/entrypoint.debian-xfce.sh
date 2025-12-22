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

exec runuser -u ${USER_NAME} -- /vncserver.sh
