#!/bin/sh

uid=$(stat -c %u /srv)
gid=$(stat -c %g /srv)

if [ $uid == 0 ] && [ $gid == 0 ]; then
    if [ $# -eq 0 ]; then
        sleep 9999d
    else
        exec "$@"
    fi
fi

sed -i -r "s/node:x:1000:1000:Linux/node:x:100:100:Linux/g" /etc/passwd

if [ $# -eq 0 ]; then
    sleep 9999d
else
    exec su-exec foo "$@"
fi
