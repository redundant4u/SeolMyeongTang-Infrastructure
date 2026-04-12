FROM alpine:3.23

RUN apk add --no-cache \
    git \
    curl

RUN curl -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.27.1/kubeseal-linux-amd64 \
    -o /usr/local/bin/kubeseal \
 && chmod +x /usr/local/bin/kubeseal
