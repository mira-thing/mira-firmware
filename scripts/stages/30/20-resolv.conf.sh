#!/bin/sh

rm -f "$ROOTFS_PATH"/etc/resolv.conf
ln -fs /var/local/etc/resolv.conf "$ROOTFS_PATH"/etc/resolv.conf

# Install dhclient exit hook so DHCP-provided DNS servers actually end up in resolv.conf
mkdir -p "$ROOTFS_PATH"/etc/dhclient-exit-hooks.d
install -m 0755 "$RES_PATH"/config/dhclient-exit-hooks/10-write-resolv \
    "$ROOTFS_PATH"/etc/dhclient-exit-hooks.d/10-write-resolv

# dhclient script default resolv.conf writer
install -m 0755 "$RES_PATH"/config/dhclient-enter-hooks \
    "$ROOTFS_PATH"/etc/dhclient-enter-hooks
