#!/bin/sh
set -e

FIREFOX_VERSION="145.0.2"

echo "Installing Firefox ${FIREFOX_VERSION}..."

# 아키텍처 감지
ARCH=$(dpkg --print-architecture)
if [ "$ARCH" = "arm64" ]; then
    MOZ_ARCH="linux-aarch64"
    echo "Detected Architecture: ARM64"
else
    MOZ_ARCH="linux-x86_64"
    echo "Detected Architecture: AMD64 (x86_64)"
fi

# 다운로드 및 설치
DOWNLOAD_URL="https://ftp.mozilla.org/pub/firefox/releases/${FIREFOX_VERSION}/${MOZ_ARCH}/en-US/firefox-${FIREFOX_VERSION}.tar.xz"

curl -L -o /tmp/firefox.tar.xz "$DOWNLOAD_URL"
echo "Download complete."

tar -xJf /tmp/firefox.tar.xz -C /opt/
ln -sf /opt/firefox/firefox /usr/bin/firefox

# 정리
rm /tmp/firefox.tar.xz
echo "Firefox installed successfully."
