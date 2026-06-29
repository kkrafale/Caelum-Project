#!/usr/bin/env bash
set -euo pipefail

ROOTFS="/opt/lake-rootfs"
OUTPUT="$(pwd)/output"
ISO_NAME="lakeOS.iso"

echo "==> Bootstrap Debian Bookworm..."
sudo debootstrap --arch=amd64 bookworm "$ROOTFS" http://deb.debian.org/debian

echo "==> Copiando configs..."
sudo cp config/sources.list  "$ROOTFS/etc/apt/sources.list"
sudo cp config/os-release    "$ROOTFS/etc/os-release"
sudo cp config/packages.list "$ROOTFS/tmp/packages.list"
sudo cp scripts/chroot-setup.sh "$ROOTFS/tmp/chroot-setup.sh"
sudo chmod +x "$ROOTFS/tmp/chroot-setup.sh"

echo "==> Montando filesystems virtuais..."
sudo mount --bind /proc    "$ROOTFS/proc"
sudo mount --bind /sys     "$ROOTFS/sys"
sudo mount --bind /dev     "$ROOTFS/dev"
sudo mount --bind /dev/pts "$ROOTFS/dev/pts"

echo "==> Rodando setup no chroot..."
sudo chroot "$ROOTFS" /tmp/chroot-setup.sh

echo "==> Desmontando..."
sudo umount "$ROOTFS/dev/pts" "$ROOTFS/dev" "$ROOTFS/sys" "$ROOTFS/proc"

echo "==> Gerando squashfs..."
mkdir -p "$OUTPUT"
sudo mksquashfs "$ROOTFS" "$OUTPUT/filesystem.squashfs" -comp xz -noappend

echo "==> Fazendo upload no Gofile (pasta j3q)..."
RESPONSE=$(curl -s -F "file=@$OUTPUT/$ISO_NAME" "https://upload.gofile.io/uploadfile?folderId=j3q")
echo "Response: $RESPONSE"
LINK=$(echo $RESPONSE | jq -r '.data.downloadPage')
echo "================================================"
echo "DOWNLOAD LINK: $LINK"
echo "================================================"

echo "==> Concluído!"
