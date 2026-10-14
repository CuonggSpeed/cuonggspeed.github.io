ARCHS = arm64 arm64e
TARGET := iphone:clang:14.5:14.0
THEOS_PACKAGE_SCHEME = roothide

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ImageCCPrefs
ImageCCPrefs_FILES = ICRootListController.m
ImageCCPrefs_CFLAGS = -fobjc-arc
ImageCCPrefs_FRAMEWORKS = UIKit
ImageCCPrefs_PRIVATE_FRAMEWORKS = Preferences
ImageCCPrefs_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk
