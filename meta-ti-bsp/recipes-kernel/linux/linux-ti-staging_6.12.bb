SECTION = "kernel"
SUMMARY = "Linux kernel for TI devices"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

inherit ti-secdev
inherit kernel

DEFAULT_PREFERENCE = "-1"

require recipes-kernel/linux/setup-defconfig.inc
require recipes-kernel/linux/ti-kernel.inc
include ${@ 'recipes-kernel/linux/ti-kernel-devicetree-prefix.inc' if d.getVar('KERNEL_DEVICETREE_PREFIX') else ''}
include ${@ 'recipes-kernel/linux/ti-extras.inc' if d.getVar('TI_EXTRAS') else ''}

DEPENDS += "gmp-native libmpc-native"

# Look in the generic major.minor directory for files
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}-6.12:"

KERNEL_EXTRA_ARGS += "LOADADDR=${UBOOT_ENTRYPOINT} \
		      ${EXTRA_DTC_ARGS}"

S = "${WORKDIR}/git"

BRANCH ?= "ti-linux-6.12.y"

SRCREV ?= "b0e715522353879e6c3c1b56dafad6fb681b1e55"
PV = "6.12.0+git"

# Special configuration for remoteproc/rpmsg IPC modules
module_conf_rpmsg_client_sample = "blacklist rpmsg_client_sample"
module_conf_ti_k3_r5_remoteproc = "softdep ti_k3_r5_remoteproc pre: virtio_rpmsg_bus"
module_conf_ti_k3_dsp_remoteproc = "softdep ti_k3_dsp_remoteproc pre: virtio_rpmsg_bus"
KERNEL_MODULE_PROBECONF += "rpmsg_client_sample ti_k3_r5_remoteproc ti_k3_dsp_remoteproc"
