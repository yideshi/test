RTL88X2BU_VERSION = 549257e6f62e8d7931e15f963aa06bb3c622ec7e
RTL88X2BU_SITE = $(call github,cilynx,rtl88x2bu,$(RTL88X2BU_VERSION))
RTL88X2BU_LICENSE = GPL-2.0
RTL88X2BU_LICENSE_FILES = LICENSE

RTL88X2BU_MODULE_MAKE_OPTS = \
	CONFIG_RTL8822BU=m \
	KVER=$(LINUX_VERSION_PROBED) \
	KBASE=$(LINUX_DIR) \
	CROSS_COMPILE=$(TARGET_CROSS)

ifeq (arm, $(filter arm, $(KERNEL_ARCH)))
RTL88X2BU_MODULE_MAKE_OPTS += CONFIG_PLATFORM_ARM_RPI=y
else
RTL88X2BU_MODULE_MAKE_OPTS += CONFIG_PLATFORM_I386_PC=y
endif

$(eval $(kernel-module))
$(eval $(generic-package))
