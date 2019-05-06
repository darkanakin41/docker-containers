FROM node:11.9-alpine

RUN apk add --no-cache su-exec git python2 make shadow g++ && \
    addgroup bar && \
    adduser -D -h /home -s /bin/sh -G bar foo

RUN usermod -u ${HOST_UID:-1001} foo && groupmod -g ${HOST_GID:-1001} bar

ADD entrypoint.sh /entrypoint

RUN ["chmod", "+x", "/entrypoint"]

ENTRYPOINT ["/entrypoint"]
