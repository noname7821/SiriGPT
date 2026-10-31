include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SiriGPT

SiriGPT_FILES = Tweak.xm
SiriGPT_FRAMEWORKS = UIKit Foundation
SiriGPT_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
SiriGPT_ARCHS = arm64 arm64e
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 14.0
SiriGPT_CFLAGS = -I.
SiriGPT_LDFLAGS = -Wl,-undefined,dynamic_lookup

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = SiriGPTPrefs

SiriGPTPrefs_FILES = SiriGPTPreferences.swift
SiriGPTPrefs_INSTALL_PATH = /Library/PreferenceBundles
SiriGPTPrefs_FRAMEWORKS = UIKit
SiriGPTPrefs_CFLAGS = -fobjc-arc
SiriGPTPrefs_ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
