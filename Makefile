ifeq ($(strip $(ANDROID_DIR)),)
$(error Please set ANDROID_DIR on the command line)
endif

ifeq ($(strip $(SDK_DIR)),)
$(error Please set SDK_DIR on the command line)
endif

CXXFLAGS = -I. -DPJ_ANDROID=1 -I$(ANDROID_DIR)/system/core/include -I$(ANDROID_DIR)/dalvik/libnativehelper/include -I$(ANDROID_DIR)/dalvik/libnativehelper/include/nativehelper -I$(ANDROID_DIR)/frameworks/base/include -I$(ANDROID_DIR)/out/target/product/generic/obj/include -I$(ANDROID_DIR)/bionic/libc/arch-arm/include -I$(ANDROID_DIR)/bionic/libc/include -I$(ANDROID_DIR)/bionic/libstdc++/include -I$(ANDROID_DIR)/bionic/libc/kernel/common -I$(ANDROID_DIR)/bionic/libc/kernel/arch-arm -I$(ANDROID_DIR)/bionic/libm/include -I$(ANDROID_DIR)/bionic/libm/include/arch/arm -I$(ANDROID_DIR)/bionic/libthread_db/include -I$(ANDROID_DIR)/bionic/libm/arm -I$(ANDROID_DIR)/bionic/libm -I$(ANDROID_DIR)/out/target/product/generic/obj/SHARED_LIBRARIES/libm_intermediates -D__ARM_ARCH_5__ -D__ARM_ARCH_5T__ -D__ARM_ARCH_5E__ -D__ARM_ARCH_5TE__ -DANDROID -DSK_RELEASE -include $(ANDROID_DIR)/system/core/include/arch/linux-arm/AndroidConfig.h -UDEBUG -DNDEBUG -march=armv5te -mtune=xscale -msoft-float -mthumb-interwork -fpic -fno-exceptions -ffunction-sections -funwind-tables -fstack-protector -fmessage-length=0 -O2 -finline-functions -finline-limit=300 -fno-inline-functions-called-once -fgcse-after-reload -frerun-cse-after-loop -frename-registers -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -fno-rtti

LDFLAGS = -nostdlib -Wl,-T,/home/jurij/android/mydroid/build/core/armelf.xsc -Wl,-shared,-Bsymbolic -L$(ANDROID_DIR)/out/target/product/generic/obj/lib -lc -lm -lm  -lssl -lcrypto -lmedia -Wl,-E $(PJSIP_LDFLAGS)

all: assets/libjniexample.so bin/JNIExample-debug.apk

assets/libjniexample.so: assets/JNIExample.cpp
	arm-eabi-g++ $(CXXFLAGS) -c -o assets/JNIExample.o assets/JNIExample.cpp
	arm-eabi-g++ $(LDFLAGS) -o assets/libjniexample.so assets/JNIExample.o 

bin/JNIExample-debug.apk: default.properties
	ant

default.properties: default.properties.in
	sed -e 's!@SDK_DIR@!$(SDK_DIR)!g' default.properties.in > default.properties

clean:
	rm -f default.properties
	cd bin && rm -rf *
	cd assets && rm -f *.so *.o
