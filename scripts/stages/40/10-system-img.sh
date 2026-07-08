#!/bin/sh

EXTRA=""
[ "${BUNDLE_VOICE:-1}" = "0" ] || EXTRA="-D xFEATURES=^has_journal"

m4 -D xFS=ext4 -D xIMAGE=system.xFS -D xLABEL="system" -D xSIZE="$SIZE_ROOT_FS" -D xUSEMKE2FS \
  -D xEXTRAARGS="-m 0" \
  $EXTRA \
  "$RES_PATH"/m4/genimage.m4 > "$WORK_PATH"/genimage_root.cfg
make_image "$ROOTFS_PATH" "$WORK_PATH"/genimage_root.cfg
