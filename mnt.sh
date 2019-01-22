#!/bin/bash

set -euxo pipefail

MOUNT_POINT=/mnt

mount "$1" "${MOUNT_POINT}"
for paths in tmp dev dev/pts sys proc etc/resolv.conf ; do
    mount --bind "/${paths}" "${MOUNT_POINT}/${paths}"
done
export PS1="chroot ${MOUNT_POINT} ${PS1:=\$}"
chroot "${MOUNT_POINT}"
for paths in etc/resolv.conf dev/pts sys proc dev tmp; do
    umount "${MOUNT_POINT}/${paths}"
done
umount "${MOUNT_POINT}"
