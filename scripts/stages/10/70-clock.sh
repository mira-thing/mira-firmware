#!/bin/sh

# Install the clock_floor service, sets the system clock to a hardcoded recent time
cp -a "$SCRIPTS_PATH"/services/clock_floor "$ROOTFS_PATH"/etc/sv/

# Install clock_sync. once any network path is up, it sets the clock ACCURATELY
# from an HTTP Date header
cp -a "$SCRIPTS_PATH"/services/clock_sync "$ROOTFS_PATH"/etc/sv/

DEFAULT_SERVICES="${DEFAULT_SERVICES} clock_floor clock_sync"
