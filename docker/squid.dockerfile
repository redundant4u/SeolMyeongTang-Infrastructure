FROM debian:trixie-slim

RUN apt-get update && apt-get install -y \
    squid=6.13-2+deb13u1 && \
    rm -rf /var/lib/apt/lists/*

USER proxy

CMD ["squid", "-N", "-f", "/etc/squid/squid.conf"]
