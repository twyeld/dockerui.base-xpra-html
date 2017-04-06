#!/bin/sh

_passwd=`getent passwd $GUEST_USER`
if [ "$_passwd" != "" ]; then
    GUEST_UID=`echo $_passwd | cut -d: -f 3`
    GUEST_GID=`echo $_passwd | cut -d: -f4`
    GUEST_GROUP=`getent group $GUEST_GID | cut -d: -f 1`
    HOME=`echo $_passwd | cut -d: -f 6`
else
    _group=`getent group $GUEST_GROUP`
    if [ "$_group" != "" ]; then
        GUEST_GID=`echo $_group | cut -d: -f 3`
    else
        groupadd -g $GUEST_GID $GUEST_GROUP
    fi
    HOME=${GUEST_HOME:-/home/$GUEST_USER}
    useradd -u $GUEST_UID -g $GUEST_GID -G xpra -d $HOME -om -s /bin/bash $GUEST_USER
    mkdir -m 700 -p /var/run/user/$GUEST_UID
    chown $GUEST_UID:$GUEST_GID $HOME /var/run/user/$GUEST_UID
    for _skel in /etc/skel/.*; do
        _file=`basename $_skel`
        [ "$_file" != . -a "$_file" != .. ] && /usr/sbin/gosu $GUEST_USER cp -p /etc/skel/$_file $HOME
    done
fi

rm -f /tmp/.X100-lock

/docker/preexecAsRoot

_args=
for _arg in "$@"; do
    [ "$_args" != '' ] && _args=$_args' '
    _args=$_args`echo $_arg | sed -r -e 's/(['\'\"\\\`' \t\n\$&|;<>%!#\\\\(){}[]|])/\\\\\1/g'`
done

exec /usr/sbin/gosu $GUEST_USER /usr/bin/xpra start $DISPLAY --no-daemon $XPRA_OPTIONS --start-child="$_args"
