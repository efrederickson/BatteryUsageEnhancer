ARCHS = armv7 arm64
TARGET = iphone:clang:8.1
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BatteryUsageEnhancer
BatteryUsageEnhancer_FILES = Tweak.xm NCBattery.xm
BatteryUsageEnhancer_FRAMEWORKS = UIKit
BatteryUsageEnhancer_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences"
