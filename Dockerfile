FROM node:13.10.1-alpine

WORKDIR /usr/src/app

RUN apk update && \
    npm install -g npm @vue/cli

RUN apk add --no-cache && \
    git && \
    bash

EXPOSE 80

CMD ["/bin/sh"]
