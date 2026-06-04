#!/bin/sh

xbps-install -r "$ROOTFS_PATH" -y NetworkManager dhclient dnsmasq ifupdown

cp -a "$SCRIPTS_PATH"/services/usb-gadget "$ROOTFS_PATH"/etc/sv/
cp -a "$SCRIPTS_PATH"/services/dhclient-usb0 "$ROOTFS_PATH"/etc/sv/

cat > "$ROOTFS_PATH"/etc/network/interfaces << EOF
auto lo
iface lo inet loopback

auto bnep0
iface bnep0 inet dhcp
EOF

cat > "$ROOTFS_PATH"/etc/NetworkManager/NetworkManager.conf << EOF
[main]
dhcp=dhclient
dns=default
rc-manager=file
EOF

cat > "$ROOTFS_PATH"/etc/NetworkManager/system-connections/usb0.nmconnection << EOF
[connection]
id=usb0
type=ethernet
interface-name=usb0
autoconnect=true

# Static config, owned by NetworkManager. Stays unconditionally 172.16.42.2 address is the
# SSH/dev target and the gateway for the PowerShell `New-NetNat` flow

[ipv4]
method=manual
address1=172.16.42.2/24,172.16.42.1
dns=1.1.1.1;8.8.8.8;
# high metric so when dhclient-usb0 adds a DHCP default route (Windows ICS /
# Linux Shared mode) that route deterministically wins over this static one
route-metric=600

# IPv6 disabled on usb0
# a small win in trying to reduce DPC pressure on windows that can cause stutters
[ipv6]
method=disabled
EOF
chmod 600 "$ROOTFS_PATH"/etc/NetworkManager/system-connections/usb0.nmconnection

echo "ENV{DEVTYPE}==\"gadget\", ENV{NM_UNMANAGED}=\"0\"" > "$ROOTFS_PATH"/usr/lib/udev/rules.d/98-network.rules

# dnsmasq config intentionally not written
mkdir -p "$ROOTFS_PATH"/etc/sysctl.d
cat > "$ROOTFS_PATH"/etc/sysctl.d/30-tcp-keepalive.conf << EOF
# Time a TCP connection sits idle before the first keepalive probe is sent.
# Default 7200s (2h); drop to 300s (5min) so NAT entries stay fresh.
net.ipv4.tcp_keepalive_time = 300
# Interval between probes once started. Default 75s; tighten to 30s.
net.ipv4.tcp_keepalive_intvl = 30
# How many probes before declaring the connection dead. Default 9; drop to 5
# so a genuinely dead link is detected within ~2.5 minutes of going bad
# instead of ~11.
net.ipv4.tcp_keepalive_probes = 5
EOF

DEFAULT_SERVICES="${DEFAULT_SERVICES} usb-gadget NetworkManager dhclient-usb0"
