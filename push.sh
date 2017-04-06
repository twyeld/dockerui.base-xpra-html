#!/bin/bash
prog=`readlink -f $0`
dir=`dirname $prog`
. $dir/version.conf

for dist in jessie xenial; do
    docker push mgtsai/dockerui.base-xpra:$VERSION_CODE-$dist
    docker push mgtsai/dockerui.base-xpra:$VERSION_MAIN-$dist
    docker push mgtsai/dockerui.base-xpra:latest-$dist
done
