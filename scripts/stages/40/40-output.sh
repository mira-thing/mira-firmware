#!/bin/sh

echo
color_echo ">> Uncompressed Sizes"
color_echo "size of root partition: $SIZE_ROOT_FS ($(du -sh "$ROOTFS_PATH" | sed "s/\s.*//") used)\n" -Yellow

color_echo ">> Compressed Sizes"
color_echo "size of install zip: $(du -sh "$OUTPUT_PATH"/mira_firmware_"$IMAGE_VERSION".zip | sed "s/\s.*//")\n" -Yellow

color_echo "$WORK_PATH" -Yellow
echo
