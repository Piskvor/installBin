#!/bin/bash
set -e

KERNEL_DIR=/boot/better-initramfs

. /usr/lib/grub/grub-mkconfig_lib

add_rescue_kernel() {
    local image_path=$1
    local message_txt="$2"
    local arch="${3:-x86}"

    if [[ "$arch" = "x64" ]]; then
        initramfs=initramfs64.cpio.gz
    else
        initramfs=initramfs.cpio.gz
    fi

    echo "$message_txt: $image" >&2
    cat << EOF
    menuentry "Rescue shell ${image_path} ${arch}" {
EOF
    cat << EOF
        insmod gzio
        insmod part_msdos
        insmod ext2
        set root='hd0,msdos1'
        linux	${KERNEL_DIR}/${image_path} rescueshell sshd binit_net_addr=dhcp
        initrd	${KERNEL_DIR}/${initramfs}
    }
EOF
}

IMAGES=$(find "$KERNEL_DIR" -not -type d -not -name 'initramfs*' | sort)
if [[ "$IMAGES" != "" ]]; then
    cat <<'EOF'
submenu 'Rescue initramfs > ' {
EOF
    for image in $IMAGES ; do
        IMAGE_PATH=$( basename "$image" )
        if [[ ! "${IMAGE_PATH}" =~ '32' ]]; then
            add_rescue_kernel "$IMAGE_PATH" "Found x64 kernel" x64
        fi
        if [[ ! "${IMAGE_PATH}" =~ '64' ]]; then
            add_rescue_kernel "$IMAGE_PATH" "Found x86 kernel" x86
        fi
    done
    cat <<'EOF'
}
EOF
fi
