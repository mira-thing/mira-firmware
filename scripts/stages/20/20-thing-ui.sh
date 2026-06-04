#!/bin/sh

UI_ZIP="${SAVED_PWD}/ui.zip"
if [ ! -f "$UI_ZIP" ]; then
  color_echo "Missing ${UI_ZIP}. Run 'just prepare' first." -Red
  exit 1
fi

curl -Lo "$WORK_PATH"/static-web-server.tar.gz https://github.com/static-web-server/static-web-server/releases/download/"$STATIC_WEB_SERVER_VERSION"/static-web-server-"$STATIC_WEB_SERVER_VERSION"-armv7-unknown-linux-musleabihf.tar.gz
tar -xvf "$WORK_PATH"/static-web-server.tar.gz --strip-components=1 --wildcards '*/static-web-server'
mv static-web-server "$ROOTFS_PATH"/usr/bin/static-web-server
chmod +x "$ROOTFS_PATH"/usr/bin/static-web-server
cp -a "$SCRIPTS_PATH"/services/thing-ui "$ROOTFS_PATH"/etc/sv/

mkdir -p "$ROOTFS_PATH"/etc/thing/ui
unzip "$UI_ZIP" -d "$ROOTFS_PATH"/etc/thing/ui

DEFAULT_SERVICES="${DEFAULT_SERVICES} thing-ui"
