#!/bin/sh

# Install the locally-built go-librespot observer binary
GLS_BIN="${SAVED_PWD}/go-librespot-armv6"
GLS_CFG="${SAVED_PWD}/go-librespot-config.yml"

if [ ! -f "$GLS_BIN" ] || [ ! -f "$GLS_CFG" ]; then
  color_echo "Missing ${GLS_BIN} or ${GLS_CFG}. Run 'just prepare' first." -Red
  exit 1
fi

install -m 0755 "$GLS_BIN" "$ROOTFS_PATH"/usr/sbin/go-librespot
cp -a "$SCRIPTS_PATH"/services/go-librespot "$ROOTFS_PATH"/etc/sv/

# svlogd writes to this dir from the log/run service script
mkdir -p "$ROOTFS_PATH"/var/log/go-librespot

mkdir -p "$ROOTFS_PATH"/etc/go-librespot
install -m 0644 "$GLS_CFG" "$ROOTFS_PATH"/etc/go-librespot/config.yml

# Primary lyrics provider env
if [ -s "${SAVED_PWD}/lp.env" ]; then
  install -m 0600 "${SAVED_PWD}/lp.env" "$ROOTFS_PATH"/etc/go-librespot/lp.env
fi

mkdir -p "$ROOTFS_PATH"/etc/thing
echo "$IMAGE_VERSION" > "$ROOTFS_PATH"/etc/thing/version.txt

DEFAULT_SERVICES="${DEFAULT_SERVICES} go-librespot"
