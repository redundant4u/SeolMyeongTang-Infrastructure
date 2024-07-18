FROM nginx:1.25-alpine

WORKDIR /home

ENV TZ=Asia/Seoul

RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apk add --update python3 py3-pip && \
    apk add certbot && \
    pip install certbot-nginx
