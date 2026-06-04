#!/bin/sh

for S in ${DEFAULT_SERVICES}; do
  if [ -d "$ROOTFS_PATH/etc/sv/$S/supervise" ]; then
    rm -rf "$ROOTFS_PATH/etc/sv/$S/supervise"
  fi

  ln -sf /run/runit/supervise."$S" "$ROOTFS_PATH"/etc/sv/"$S"/supervise
  ln -sf /etc/sv/"$S" "$ROOTFS_PATH"/etc/runit/runsvdir/default/

  # Services that ship with a log/ subdir also need their log supervisor state to live on tmpfs
  if [ -d "$ROOTFS_PATH/etc/sv/$S/log" ]; then
    if [ -d "$ROOTFS_PATH/etc/sv/$S/log/supervise" ]; then
      rm -rf "$ROOTFS_PATH/etc/sv/$S/log/supervise"
    fi
    ln -sf /run/runit/supervise."$S".log "$ROOTFS_PATH"/etc/sv/"$S"/log/supervise
  fi
done

rm "$ROOTFS_PATH"/etc/runit/runsvdir/default/agetty-*
