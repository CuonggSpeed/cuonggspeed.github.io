ARCHS = arm64 arm64e
TARGET := iphone:clang:14.5:14.0
THEOS_PACKAGE_SCHEME = roothide

include $(THEOS)/makefiles/common.mk

SUBPROJECTS = Module Prefs

include $(THEOS_MAKE_PATH)/aggregate.mk
