#!/bin/bash
GUEST_USER=${GUEST_USER:-user}
GUEST_GROUP=${GUEST_GROUP:-user}
GUEST_UID=${GUEST_UID:-9001}
GUEST_GID=${GUEST_GID:-9001}
export HOME=${GUEST_HOME:-/home/$GUEST_USER}

userdel $GUEST_USER
groupdel $GUEST_GROUP
groupadd -g $GUEST_GID $GUEST_GROUP
useradd -u $GUEST_UID -g $GUEST_GID -d $HOME -om -s /bin/bash $GUEST_USER
chown $GUEST_UID:$GUEST_GID $HOME

rm -f /tmp/.X100-lock
/usr/sbin/gosu $GUEST_USER /usr/bin/xpra start $DISPLAY $XPRA_OPTIONS
sleep 2

GUEST_USER=$GUEST_USER GUEST_GROUP=$GUEST_GROUP GUEST_UID=$GUEST_UID GUEST_GID=$GUEST_GID /preexecAsRoot.sh
exec /usr/sbin/gosu $GUEST_USER $@
