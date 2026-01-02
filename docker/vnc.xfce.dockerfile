FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    VNC_DISPLAY=:1 \
    VNC_GEOMETRY=1600x900 \
    VNC_DEPTH=24

RUN apt-get update && apt-get install -y --no-install-recommends \
      tigervnc-standalone-server \
      tigervnc-tools \
      tini \
      xfce4 xfce4-terminal dbus-x11 \
      firefox-esr fonts-dejavu-core

RUN apt-get install -y \
    sudo \
    && rm -rf /var/lib/apt/lists/*

COPY docker/data/vnc/xstartup.debian-xfce /xstartup
COPY docker/data/vnc/entrypoint.debian-xfce.sh /entrypoint.sh
COPY docker/data/vnc/vncserver.debian-xfce.sh /vncserver.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
