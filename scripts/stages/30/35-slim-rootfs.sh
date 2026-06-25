#!/bin/sh

# Slim the read-only system_a rootfs so we can fit everything into the 516MiB partitions
if [ "${BUNDLE_VOICE:-1}" = "0" ]; then
  return 0 2>/dev/null || exit 0
fi

R="$ROOTFS_PATH"

rm -f  "$R"/etc/udev/hwdb.bin
rm -rf "$R"/usr/lib/udev/hwdb.d
rm -f "$R"/usr/share/misc/magic.mgc
rm -f "$R"/usr/bin/file
rm -f "$R"/usr/lib/libmagic.so.1 "$R"/usr/lib/libmagic.so.1.0.0
rm -rf "$R"/var/db/xbps
rm -rf "$R"/usr/share/i18n

color_echo "  Stage 30 - rootfs slimmed for voice" -Green
