FROM ubuntu:16.04

COPY keys/ /tmp/keys/

RUN apt-get update && apt-get install dirmngr -y && apt-key adv --fetch-keys http://xpra.org/gpg.asc

RUN apt-key add /tmp/keys/xpra.org-20180504.asc && \
    echo "deb http://xpra.org/ xenial main" > /etc/apt/sources.list.d/xpra.list && \
    apt-get update && \
    apt-get install -q -y gosu dbus-x11 libgtk2.0-0 libcanberra-gtk-module xpra=2.0.2-r15657-1 x11-apps xterm

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN mkdir -m 770 /var/run/xpra && \
    chgrp xpra /var/run/xpra

ENV GUEST_USER=user \
    GUEST_UID=9001 \
    GUEST_GROUP=user \
    GUEST_GID=9001 \
    DISPLAY=:0 \
    XPRA_OPTIONS="--bind-tcp=0.0.0.0:14500 --html=on"

ADD common/ debian-series/ /docker/
RUN chmod a+x /docker/*
EXPOSE 14500
ENTRYPOINT ["/docker/entrypoint.sh"]
CMD xterm
