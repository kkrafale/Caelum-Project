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
# Garante sources.list correto no sistema live
cat > /etc/apt/sources.list << 'EOF'
deb http://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security trixie-security main
deb http://deb.debian.org/debian trixie-updates main
EOF
mkdir -p /usr/share/pixmaps
cp /tmp/lakeos-circle.png /usr/share/pixmaps/lakeos.png
cp /tmp/lakeos-white.png /usr/share/pixmaps/lakeos-menu.png
mkdir -p /home/lake/.config/fastfetch
cat > /home/lake/.config/fastfetch/config.jsonc << 'EOF'
{
    "logo": {
        "source": "/usr/share/pixmaps/lakeos.png",
        "type": "kitty",
        "width": 20,
        "height": 10
    }
}
EOF
chown -R lake:lake /home/lake/.config
mkdir -p /usr/share/icons/hicolor/256x256/apps
cp /usr/share/pixmaps/lakeos-menu.png /usr/share/icons/hicolor/256x256/apps/lakeos-white.png
gtk-update-icon-cache /usr/share/icons/hicolor/ || true
echo "==> Limpando..."
apt-get clean
apt-get autoremove -y
rm -rf /var/lib/apt/lists/*
rm -f /tmp/chroot-setup.sh
