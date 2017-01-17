export TARGET = iphone:9.0:9.0
include $(THEOS)/makefiles/common.mk

#GO_EASY_ON_ME=1

TWEAK_NAME = Photicon

$(TWEAK_NAME)_FILES = PHPreferences.m UIImage+PHExtensions.m Tweak.xm
$(TWEAK_NAME)_FRAMEWORKS = UIKit
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = PhotoLibraryServices
$(TWEAK_NAME)_LDFLAGS += -fobjc-arc
$(TWEAK_NAME)_CFLAGS += -D THEOSBUILD=1

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
