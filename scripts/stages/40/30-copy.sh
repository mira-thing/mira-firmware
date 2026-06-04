#!/bin/sh

rm "$OUTPUT_PATH"/* 2> /dev/null || true

mv "$IMAGE_PATH"/system.ext4 "$IMAGE_PATH"/system_a.ext2
cp "$IMAGE_PATH"/system_a.ext2 "$IMAGE_PATH"/system_b.ext2

cd "$RES_PATH"/stock-files/extract/ || exit 1
# Stock partitions copied verbatim
cp bootloader.dump dtbo_a.dump dtbo_b.dump fip_a.dump fip_b.dump misc.dump vbmeta_a.dump vbmeta_b.dump "$IMAGE_PATH"/

# Custom kernel
CUSTOM_BOOT="$RES_PATH"/kernel/boot_custom.dump
if [ ! -f "$CUSTOM_BOOT" ]; then
  color_echo "Missing $CUSTOM_BOOT — build the kernel + boot image first (see the thing-kernel repo)." -Red
  exit 1
fi
cp "$CUSTOM_BOOT" "$IMAGE_PATH"/boot_a.dump
cp "$CUSTOM_BOOT" "$IMAGE_PATH"/boot_b.dump

cp "$RES_PATH"/flash/env.txt "$RES_PATH"/flash/logo.dump "$IMAGE_PATH"/

cd "$IMAGE_PATH"/ || exit 1
zip -r9 "$OUTPUT_PATH"/thing_firmware_"$IMAGE_VERSION".zip .
