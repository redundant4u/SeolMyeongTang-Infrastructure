FROM nginx:1.23-alpine

WORKDIR /home

ENV NODE_ENV=prod \
    TZ=Asia/Seoul

RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apk add --update python3 py3-pip && \
    apk add certbot && \
    pip install certbot-nginx
