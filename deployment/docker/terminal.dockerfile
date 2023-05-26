FROM ubuntu:22.04

RUN useradd -U -u 999 -d /home/seol -m -l seol && \
    mkdir -p /home/seol/bin && \
    cp /bin/ls /home/seol/bin/ls && \
    cp /bin/cat /home/seol/bin/cat && \
    cp /bin/clear /home/seol/bin/clear && \
    rm /home/seol/.bash_logout /home/seol/.profile

COPY docker/data/terminal/me /home/seol/me
COPY docker/data/terminal/bashrc /home/seol/.bashrc
COPY docker/data/terminal/inputrc /home/seol/.inputrc

USER seol

WORKDIR /home/seol
