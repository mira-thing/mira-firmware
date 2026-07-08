#!/bin/sh

xbps-install -r "$ROOTFS_PATH" -y NetworkManager dhclient dnsmasq ifupdown

cp -a "$SCRIPTS_PATH"/services/usb-gadget "$ROOTFS_PATH"/etc/sv/
cp -a "$SCRIPTS_PATH"/services/dhclient-usb0 "$ROOTFS_PATH"/etc/sv/
cp -a "$SCRIPTS_PATH"/services/dhclient-usb1 "$ROOTFS_PATH"/etc/sv/

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
# resolv.conf is a symlink into /var/local
rc-manager=unmanaged

# usb1 (ECM) belongs to dhclient-usb1
[keyfile]
unmanaged-devices=interface-name:usb1
EOF

cat > "$ROOTFS_PATH"/etc/NetworkManager/system-connections/usb0.nmconnection << EOF
[connection]
id=usb0
type=ethernet
interface-name=usb0
autoconnect=true

[ipv4]
method=manual
address1=172.16.42.2/24,172.16.42.1
dns=1.1.1.1;8.8.8.8;
# high metric
route-metric=600

# IPv6 disabled
[ipv6]
method=disabled
EOF
chmod 600 "$ROOTFS_PATH"/etc/NetworkManager/system-connections/usb0.nmconnection

echo "ENV{DEVTYPE}==\"gadget\", ENV{NM_UNMANAGED}=\"0\"" > "$ROOTFS_PATH"/usr/lib/udev/rules.d/98-network.rules

# dnsmasq config intentionally not written
mkdir -p "$ROOTFS_PATH"/etc/sysctl.d
cat > "$ROOTFS_PATH"/etc/sysctl.d/30-tcp-keepalive.conf << EOF
# Time a TCP connection sits idle before the first keepalive probe is sent
net.ipv4.tcp_keepalive_time = 300
# Interval between probes once started
net.ipv4.tcp_keepalive_intvl = 30
# How many probes before declaring the connection dead
net.ipv4.tcp_keepalive_probes = 5
EOF

DEFAULT_SERVICES="${DEFAULT_SERVICES} usb-gadget NetworkManager dhclient-usb0 dhclient-usb1"
