#!/bin/sh

xbps-install -r "$ROOTFS_PATH" -y openssh iptables

rm -f "$ROOTFS_PATH"/etc/motd "$ROOTFS_PATH"/etc/fstab
cp "$RES_PATH"/config/motd "$ROOTFS_PATH"/etc/motd
cp "$RES_PATH"/config/fstab "$ROOTFS_PATH"/etc/fstab

ln -sf /var/local/etc/localtime "$ROOTFS_PATH"/etc/localtime

echo "$DEFAULT_HOSTNAME" > "$ROOTFS_PATH"/etc/hostname

root_pw=$(mkpasswd -m sha-512 -s "$DEFAULT_ROOT_PASSWORD")
sed -i "/^root/d" "$ROOTFS_PATH"/etc/shadow
echo "root:${root_pw}:19000:0:99999::::" >> "$ROOTFS_PATH"/etc/shadow
"$HELPERS_PATH"/chroot_exec.sh chsh -s /bin/bash root

cp "$RES_PATH"/config/sshd_config "$ROOTFS_PATH"/etc/sshd_config

rm -rf "$ROOTFS_PATH"/etc/ssh
ln -sf /var/local/etc/ssh "$ROOTFS_PATH"/etc/ssh

cat > "$ROOTFS_PATH"/etc/sv/sshd/conf << 'EOF'
iptables -C INPUT -i bnep0 -p tcp --dport 22 -j REJECT 2>/dev/null || \
    iptables -I INPUT -i bnep0 -p tcp --dport 22 -j REJECT || \
    echo "sshd: failed to install bnep0 ssh guard"
ip6tables -C INPUT -i bnep0 -p tcp --dport 22 -j REJECT 2>/dev/null || \
    ip6tables -I INPUT -i bnep0 -p tcp --dport 22 -j REJECT || \
    echo "sshd: failed to install bnep0 ssh guard (v6)"
EOF

DEFAULT_SERVICES="${DEFAULT_SERVICES} sshd"
