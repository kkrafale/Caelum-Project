#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "lakeos" > /etc/hostname

apt-get update
apt-get install -y sudo curl wget git nano network-manager live-boot live-config

# KDE Plasma
apt-get install -y \
  kde-plasma-desktop \
  sddm \
  konsole \
  dolphin \
  plasma-nm

systemctl enable sddm

# Usuário padrão
useradd -m -s /bin/bash lake
echo "lake:lake" | chpasswd
usermod -aG sudo lake

apt-get clean
rm -f /tmp/chroot-setup.sh
