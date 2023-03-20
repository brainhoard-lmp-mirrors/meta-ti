PV:k3 = "2.8+git${SRCPV}"
SRCREV_tfa:k3 = "2fcd408bb3a6756767a43c073c597cef06e7f2d5"
SRC_URI:k3 = "git://git.trustedfirmware.org/TF-A/trusted-firmware-a.git;protocol=https;name=tfa;branch=master"
COMPATIBLE_MACHINE:k3 = "k3"
TFA_BUILD_TARGET:k3 = "all"
TFA_INSTALL_TARGET:k3 = "bl31"
TFA_SPD:k3 = "opteed"

# Use TI SECDEV for signing
inherit ti-secdev

EXTRA_OEMAKE:append:k3 = "${@ ' K3_USART=' + d.getVar('TFA_K3_USART') if d.getVar('TFA_K3_USART') else ''}"
EXTRA_OEMAKE:append:k3 = "${@ ' K3_PM_SYSTEM_SUSPEND=' + d.getVar('TFA_K3_SYSTEM_SUSPEND') if d.getVar('TFA_K3_SYSTEM_SUSPEND') else ''}"

# Signing procedure for K3 devices
do_compile:append:k3() {
	mv ${BUILD_DIR}/bl31.bin ${BUILD_DIR}/bl31.bin.unsigned
	${TI_SECURE_DEV_PKG}/scripts/secure-binary-image.sh ${BUILD_DIR}/bl31.bin.unsigned ${BUILD_DIR}/bl31.bin
}

do_install:append:k3() {
    if [ -f ${BUILD_DIR}/bl31.bin.unsigned ]; then
        echo "Install bl31.bin.unsigned"
        install -m 0644 ${BUILD_DIR}/bl31.bin.unsigned \
        ${D}/firmware/bl31.bin.unsigned
    else
        echo "Install bl31.bin.unsigned"
        install -m 0644 ${BUILD_DIR}/bl31.bin \
        ${D}/firmware/bl31.bin.unsigned
    fi
}
