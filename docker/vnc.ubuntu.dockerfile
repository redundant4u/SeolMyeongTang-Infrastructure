FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    VNC_DISPLAY=:1 \
    VNC_GEOMETRY=1600x900 \
    VNC_DEPTH=24 \
    LIBGL_ALWAYS_SOFTWARE=1 \
    XDG_SESSION_TYPE=x11 \
    GDK_BACKEND=x11 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
        tigervnc-standalone-server \
        tigervnc-tools \
        ubuntu-desktop-minimal \
        gnome-terminal \
        gnome-session-flashback \
        dbus-x11 \
        locales \
        fonts-ubuntu \
        fonts-noto-cjk \
        fonts-noto-color-emoji \
        fonts-liberation \
        fontconfig \
        sudo \
        tini \
        wget \
        curl \
        vim \
        bzip2 \
        indicator-applet \
        indicator-application && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get remove -y --purge \
        update-notifier \
        update-notifier-common \
        update-manager \
        update-manager-core && \
    apt-get autoremove -y

COPY docker/data/vnc/xstartup.ubuntu /xstartup
COPY docker/data/vnc/entrypoint.ubuntu.sh /entrypoint.sh
COPY docker/data/vnc/vncserver.ubuntu.sh /vncserver.sh

COPY docker/data/vnc/install_firefox.sh /install_firefox.sh

RUN /install_firefox.sh && rm /install_firefox.sh && \
    echo 'Acquire::http::Proxy "http://vnc-gateway:3128";' > /etc/apt/apt.conf.d/95proxy && \
    echo 'Acquire::https::Proxy "http://vnc-gateway:3128";' >> /etc/apt/apt.conf.d/95proxy

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
