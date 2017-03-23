<!--
    Copyright (C) 2017-2022, Joseph M. G. Tsai
    under the terms of the Apache License, Version 2.0 (ALv2),
    found at http://www.apache.org/licenses/LICENSE-2.0
-->

# dockerui.base-xpra

Provide base docker images for X applications by using [Xpra](https://xpra.org/) as the X11 server.


## Supported tags and respective `Dockerfile` links

* [`2.0-xenial` (Dockerfile-xenial)](https://github.com/mgtsai/dockerui.base-xpra/blob/master/Dockerfile-xenial):
  Xpra version 2.0-r15319-1 based on Ubuntu Xenial (16.04)


## Brief description

By default, the Xpra server in a docker image only exposes the default UNIX domain socket `${HOME}/.xpra/${HOSTNAME}-100`
for Xpra service.  To enable accessing the Xpra server via network, the environment variable `XPRA_OPTIONS` would be
applied with the following Xpra startup command: `xpra start ${DISPLAY} ${XPRA_OPTIONS}`.

You can browse <http://xpra.org/manual.html> for more Xpra options in detail.

If ones wish to run the Xpra server and X11 applications under a specific user/group, several environment variables
are used for this purpose to control the execution uid/gid of the Xpra server and other X11 applications (such as
various IDE software), described as following:

  Environment variable | Default value
  ---------------------|--------------
  GUEST_USER           | user
  GUEST_GROUP          | user
  GUEST_UID            | 9001
  GUEST_GID            | 9001

The Docker images provided by this project can also be inherited by other descend images.  The command listed in
Dockerfile instruction `CMD` is executed under the uid/gid specified by environment variables `GUEST_UID` and
`GUEST_GID`.


## Examples

* Start Xpra by creating TCP port 14500 (INSECURE), and run `xclock` application.  Users can use Xpra clients to show
`xclock`
```text
docker run --rm --env XPRA_OPTIONS="--bind-tcp=0.0.0.0:14500" mgtsai/dockerui.base-xpra:2.0-xenial xclock
```

* Start Xpra by creating TCP port 14500 (INSECURE), and run `xclock` with uid 2001 and gid 2001 
```text
docker run --rm --env XPRA_OPTIONS="--bind-tcp=0.0.0.0:14500" --env GUEST_UID=2001 --env GUEST_GID=2001 mgtsai/dockerui.base-xpra:2.0-xenial xclock
```

* Start Xpra by creating TCP port 14500 and HTTP server (INSECURE), and run `xclock`.  Users can use browsers by url
<http://hostname:14500/index.html> to show `xclock`
```text
docker run --rm --env XPRA_OPTIONS="--bind-tcp=0.0.0.0:14500" mgtsai/dockerui.base-xpra:2.0-xenial xclock
```
