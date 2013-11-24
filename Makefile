SOURCES = \
	SimpleLibOVR.cpp \
	LibOVR/Src/Kernel/OVR_Alg.cpp \
	LibOVR/Src/Kernel/OVR_Allocator.cpp \
	LibOVR/Src/Kernel/OVR_Atomic.cpp \
	LibOVR/Src/Kernel/OVR_File.cpp \
	LibOVR/Src/Kernel/OVR_FileFILE.cpp \
	LibOVR/Src/Kernel/OVR_Log.cpp \
	LibOVR/Src/Kernel/OVR_Math.cpp \
	LibOVR/Src/Kernel/OVR_RefCount.cpp \
	LibOVR/Src/Kernel/OVR_Std.cpp \
	LibOVR/Src/Kernel/OVR_String.cpp \
	LibOVR/Src/Kernel/OVR_String_FormatUtil.cpp \
	LibOVR/Src/Kernel/OVR_String_PathUtil.cpp \
	LibOVR/Src/Kernel/OVR_SysFile.cpp \
	LibOVR/Src/Kernel/OVR_System.cpp \
	LibOVR/Src/Kernel/OVR_Timer.cpp \
	LibOVR/Src/Kernel/OVR_UTF8Util.cpp \
	LibOVR/Src/OVR_DeviceHandle.cpp \
	LibOVR/Src/OVR_DeviceImpl.cpp \
	LibOVR/Src/OVR_JSON.cpp \
	LibOVR/Src/OVR_LatencyTestImpl.cpp \
	LibOVR/Src/OVR_Profile.cpp \
	LibOVR/Src/OVR_SensorFilter.cpp \
	LibOVR/Src/OVR_SensorFusion.cpp \
	LibOVR/Src/OVR_SensorImpl.cpp \
	LibOVR/Src/OVR_ThreadCommandQueue.cpp \
	LibOVR/Src/Util/Util_LatencyTest.cpp \
	LibOVR/Src/Util/Util_MagCalibration.cpp \
	LibOVR/Src/Util/Util_Render_Stereo.cpp

OSX_SOURCES = \
	LibOVR/Src/Kernel/OVR_ThreadsPthread.cpp \
	LibOVR/Src/OVR_OSX_DeviceManager.cpp \
	LibOVR/Src/OVR_OSX_HIDDevice.cpp \
	LibOVR/Src/OVR_OSX_HMDDevice.cpp \
	LibOVR/Src/OVR_OSX_SensorDevice.cpp

LINUX_SOURCES = \
	LibOVR/Src/Kernel/OVR_ThreadsPthread.cpp \
	LibOVR/Src/OVR_Linux_DeviceManager.cpp \
	LibOVR/Src/OVR_Linux_HIDDevice.cpp \
	LibOVR/Src/OVR_Linux_HMDDevice.cpp \
	LibOVR/Src/OVR_Linux_SensorDevice.cpp

WINDOWS_SOURCES = \
	LibOVR/Src/Kernel/OVR_ThreadsWinAPI.cpp \
	LibOVR/Src/OVR_Win32_DeviceManager.cpp \
	LibOVR/Src/OVR_Win32_DeviceStatus.cpp \
	LibOVR/Src/OVR_Win32_HIDDevice.cpp \
	LibOVR/Src/OVR_Win32_HMDDevice.cpp \
	LibOVR/Src/OVR_Win32_SensorDevice.cpp

FLAGS = \
	-I LibOVR/Include \
	-I LibOVR/Src

build-osx:
	$(CC) $(FLAGS) $(SOURCES) $(OSX_SOURCES) -framework Carbon -framework IOKit -lc++ -shared -arch i386 -arch x86_64 -o libSimpleLibOVR.dylib

build-linux:
	$(CC) $(FLAGS) $(SOURCES) $(LINUX_SOURCES) # TODO: Figure out the correct flags

build-windows:
	$(CC) $(FLAGS) $(SOURCES) $(WINDOWS_SOURCES) # TODO: Figure out the correct flags
