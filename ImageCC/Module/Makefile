ARCHS = arm64 arm64e
TARGET := iphone:clang:14.5:14.0
THEOS_PACKAGE_SCHEME = roothide

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ImageModule
ImageModule_FILES = ImageModule.m
ImageModule_CFLAGS = -fobjc-arc
ImageModule_FRAMEWORKS = UIKit
ImageModule_INSTALL_PATH = /Library/ControlCenter/Bundles

include $(THEOS_MAKE_PATH)/bundle.mk
