FROM node:13.10.1-alpine

COPY ./ /usr/src/app/

WORKDIR /usr/src/app/

RUN apk update && \
    npm install -g npm @vue/cli

RUN apk add --no-cache \
    git \
    bash \
    make \
    grep \
    openssh

RUN git clone https://github.com/awslabs/git-secrets /var/opt/git-secrets && \
    cd /var/opt/git-secrets && \
    make install

RUN git secrets --install -f && \
    git secrets --register-aws

EXPOSE 80

CMD ["/bin/sh"]
