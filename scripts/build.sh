#!/usr/bin/env bash
set -euo pipefail

ROOTFS="/opt/lake-rootfs"
ISO_ROOT="/opt/lake-iso"
OUTPUT="$(pwd)/output"
ISO_NAME="lakeOS.iso"

# Limpa rootfs antigo se existir
if mountpoint -q "$ROOTFS/proc" 2>/dev/null; then
    sudo umount -lf "$ROOTFS/dev/pts" || true
    sudo umount -lf "$ROOTFS/dev"     || true
    sudo umount -lf "$ROOTFS/sys"     || true
    sudo umount -lf "$ROOTFS/proc"    || true
fi

echo "==> Bootstrap Debian Bookworm..."
sudo debootstrap --arch=amd64 bookworm "$ROOTFS" http://deb.debian.org/debian

echo "==> Copiando configs..."
sudo cp config/sources.list      "$ROOTFS/etc/apt/sources.list"
sudo cp config/os-release        "$ROOTFS/etc/os-release"
sudo cp config/packages.list     "$ROOTFS/tmp/packages.list"
sudo cp scripts/chroot-setup.sh  "$ROOTFS/tmp/chroot-setup.sh"
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

echo "==> Montando estrutura do ISO..."
sudo rm -rf "$ISO_ROOT"
sudo mkdir -p "$ISO_ROOT"/{live,boot/grub}

sudo cp "$OUTPUT/filesystem.squashfs"    "$ISO_ROOT/live/"
sudo cp "$ROOTFS/boot"/vmlinuz-*         "$ISO_ROOT/boot/vmlinuz"
sudo cp "$ROOTFS/boot"/initrd.img-*      "$ISO_ROOT/boot/initrd.img"

sudo tee "$ISO_ROOT/boot/grub/grub.cfg" > /dev/null << 'EOF'
set default=0
set timeout=5

menuentry "LakeOS" {
    linux  /boot/vmlinuz boot=live quiet splash
    initrd /boot/initrd.img
}

menuentry "LakeOS (modo seguro)" {
    linux  /boot/vmlinuz boot=live nomodeset
    initrd /boot/initrd.img
}
EOF

echo "==> Gerando ISO bootável..."
sudo grub-mkrescue -o "$OUTPUT/$ISO_NAME" "$ISO_ROOT" -- -volid "LAKEOS"

echo "==> Fazendo upload no Gofile (pasta j3q)..."
RESPONSE=$(curl -s -F "file=@$OUTPUT/$ISO_NAME" "https://upload.gofile.io/uploadfile?folderId=j3q")
echo "Response: $RESPONSE"
LINK=$(echo "$RESPONSE" | jq -r '.data.downloadPage')
echo "================================================"
echo "DOWNLOAD LINK: $LINK"
echo "================================================"
echo "==> Concluído!"
