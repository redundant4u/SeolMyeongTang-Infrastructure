FROM ubuntu:22.04

WORKDIR /home/seol

RUN apt-get update && apt-get install openssh-server -y

COPY \
    docker/data/terminal/me \
    docker/data/terminal/bashrc \
    docker/data/terminal/bash_profile \
    docker/data/terminal/inputrc \
    docker/data/terminal/script.sh \
    ./

RUN ./script.sh

USER seol
