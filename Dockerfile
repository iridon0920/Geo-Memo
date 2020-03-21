# syntax = docker/dockerfile:experimental
FROM node:13.10.1-alpine

RUN apk update && \
    npm install -g npm @vue/cli

RUN apk add --no-cache \
    git \
    bash \
    openssh \
    make

RUN --mount=type=secret,id=ssh,dst=/root/.ssh/id_rsa \
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts && \
    git clone git@github.com:iridon0920/geo-memo.git /usr/src/app/geo-memo && \
    git clone git@github.com:awslabs/git-secrets.git /var/opt/git-secrets && \
    cd /var/opt/git-secrets && \
    make install

WORKDIR /usr/src/app/geo-memo

RUN git secrets --install

EXPOSE 80

CMD ["/bin/sh"]
