#!/bin/sh

xbps-install -r "$ROOTFS_PATH" -y bluez dbus

mkdir -p "$ROOTFS_PATH"/lib/firmware/brcm
cp "$RES_PATH"/firmware/brcm/* "$ROOTFS_PATH"/lib/firmware/brcm/

cp -a "$SCRIPTS_PATH"/services/bluetooth_adapter "$ROOTFS_PATH"/etc/sv/
cp -a "$SCRIPTS_PATH"/services/superbird_init "$ROOTFS_PATH"/etc/sv/

mkdir -p "$ROOTFS_PATH"/etc/bluetooth
rm -f "$ROOTFS_PATH"/etc/bluetooth/main.conf
cp "$RES_PATH"/config/bluetooth.conf "$ROOTFS_PATH"/etc/bluetooth/main.conf

# disable bluez LE audio plugins
printf 'OPTS="-P bap,bass,csip,mcp,ccp,vcp,micp"\n' > "$ROOTFS_PATH"/etc/sv/bluetoothd/conf

# Note: bluetooth_pairing is intentionally NOT installed, it races the 
# daemons agent for the default-agent slot
DEFAULT_SERVICES="${DEFAULT_SERVICES} dbus bluetoothd bluetooth_adapter superbird_init"
