#!/bin/bash
prog=`readlink -f $0`
dir=`dirname $prog`
. $dir/version.conf

echo > $dir/.env
echo VERSION_CODE=$VERSION_CODE >> $dir/.env
echo VERSION_MAIN=$VERSION_MAIN >> $dir/.env

(cd $dir; docker-compose build) || exit 1

for dist in jessie xenial; do
    docker tag mgtsai/dockerui.base-xpra:$VERSION_CODE-$dist mgtsai/dockerui.base-xpra:$VERSION_MAIN-$dist
    docker tag mgtsai/dockerui.base-xpra:$VERSION_CODE-$dist mgtsai/dockerui.base-xpra:latest-$dist
done
