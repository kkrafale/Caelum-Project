#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

echo "lakeos" > /etc/hostname

cat > /etc/hosts << 'HOSTS'
127.0.0.1   localhost
127.0.1.1   lakeos
HOSTS

apt-get update

echo "==> Instalando base + live system..."
apt-get install -y \
    sudo curl wget git nano \
    network-manager \
    linux-image-amd64 \
    live-boot \
    live-boot-initramfs-tools \
    live-config \
    live-config-systemd \
    systemd-sysv \
    dbus

echo "==> Instalando KDE Plasma..."
apt-get install -y \
    kde-plasma-desktop \
    sddm \
    konsole \
    dolphin \
    plasma-nm \
    kde-spectacle \
    gwenview \
    okular

echo "==> Configurando SDDM..."
systemctl enable sddm
systemctl enable NetworkManager

echo "==> Criando usuário lake..."
useradd -m -s /bin/bash lake
echo "lake:lake" | chpasswd
passwd -u lake
usermod -aG sudo,audio,video,plugdev lake

echo "==> Identidade do sistema..."
cat > /etc/os-release << 'OSRELEASE'
NAME="LakeOS"
VERSION="1.0"
ID=lakeos
ID_LIKE=debian
PRETTY_NAME="LakeOS 1.0"
HOME_URL="https://github.com/seu-usuario/lakeOS"
OSRELEASE

echo "==> Configurando autologin SDDM..."
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/autologin.conf << 'SDDM'
[Autologin]
User=lake
Session=plasma
SDDM

echo "==> Forçando SDDM no live boot..."
mkdir -p /etc/systemd/system/display-manager.service.d
cat > /etc/systemd/system/display-manager.service.d/override.conf << 'OVERRIDE'
[Service]
ExecStartPre=/bin/sleep 10
OVERRIDE

systemctl set-default graphical.target
systemctl mask live-config.service || true
echo "==> Limpando..."
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*
rm -f /tmp/chroot-setup.sh
