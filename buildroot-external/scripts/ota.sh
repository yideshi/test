#!/bin/bash

function create_ota_update() {
    local ota_file="$(hassos_image_name raucb)"
    local rauc_folder="${BINARIES_DIR}/rauc"
    local boot="${BINARIES_DIR}/boot.vfat"
    local kernel="${BINARIES_DIR}/kernel.ext4"
    local rootfs="${BINARIES_DIR}/rootfs.squashfs"
    local key="/build/key.pem"
    local cert="/build/cert.pem"

    rm -rf ${rauc_folder} ${ota_file}
    mkdir -p ${rauc_folder}

    cp -f ${kernel} ${rauc_folder}/kernel.ext4
    cp -f ${boot} ${rauc_folder}/boot.vfat
    cp -f ${rootfs} ${rauc_folder}/rootfs.img
    cp -f ${BR2_EXTERNAL_HASSOS_PATH}/misc/rauc-hook ${rauc_folder}/hook

    (
        echo "[update]"
        echo "compatible=$(hassos_rauc_compatible)"
        echo "version=$(hassos_version)"
        echo "[hooks]"
        echo "filename=hook"
        echo "[image.boot]"
        echo "filename=boot.vfat"
        echo "hooks=pre-install;post-install"
        echo "[image.kernel]"
        echo "filename=kernel.ext4"
        echo "[image.rootfs]"
        echo "filename=rootfs.img"
    ) > ${rauc_folder}/manifest.raucm

    rauc bundle -d --cert=${cert} --key=${key} ${rauc_folder} ${ota_file}
}
