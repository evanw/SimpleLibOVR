#include "OVR.h"

#define PACKED __attribute__((packed))

// Portable version of OVR::HMDInfo
struct HMDInfo {
  // Size of the entire screen, in pixels.
  int HResolution, VResolution;

  // Physical dimensions of the active screen in meters. Can be used to calculate
  // projection center while considering IPD.
  float HScreenSize, VScreenSize;

  // Physical offset from the top of the screen to the eye center, in meters.
  // This will usually, but not necessarily be half of VScreenSize.
  float VScreenCenter;

  // Distance from the eye to screen surface, in meters.
  // Useful for calculating FOV and projection.
  float EyeToScreenDistance;

  // Distance between physical lens centers useful for calculating distortion center.
  float LensSeparationDistance;

  // Configured distance between the user's eye centers, in meters. Defaults to 0.064.
  float InterpupillaryDistance;

  // Radial distortion correction coefficients.
  // The distortion assumes that the input texture coordinates will be scaled
  // by the following equation:
  //   uvResult = uvInput * (K0 + K1 * uvLength^2 + K2 * uvLength^4)
  // Where uvInput is the UV vector from the center of distortion in direction
  // of the mapped pixel, uvLength is the magnitude of that vector, and uvResult
  // the corresponding location after distortion.
  float DistortionK[4];

  float ChromaAbCorrection[4];

  // Desktop coordinate position of the screen (can be negative; may not be present on all platforms)
  int DesktopX, DesktopY;
} PACKED;

// Portable version of OVR::Quatf
struct Quaternion {
  float x, y, z, w;
} PACKED;

static OVR::Ptr<OVR::DeviceManager> manager;
static OVR::Ptr<OVR::SensorDevice> sensor;
static OVR::Ptr<OVR::HMDDevice> hmd;
static OVR::SensorFusion fusion;
static OVR::HMDInfo info;

extern "C" bool SimpleLibOVR_Setup() {
  OVR::System::Init();
  if (!(manager = *OVR::DeviceManager::Create())) return false;
  if (!(hmd = *manager->EnumerateDevices<OVR::HMDDevice>().CreateDevice())) return false;
  if (!(sensor = *hmd->GetSensor())) return false;
  if (!hmd->GetDeviceInfo(&info)) return false;
  if (!fusion.AttachToSensor(sensor)) return false;
  return true;
}

extern "C" void SimpleLibOVR_Info(HMDInfo *info) {
  info->HResolution = ::info.HResolution;
  info->VResolution = ::info.VResolution;
  info->HScreenSize = ::info.HScreenSize;
  info->VScreenSize = ::info.VScreenSize;
  info->VScreenCenter = ::info.VScreenCenter;
  info->EyeToScreenDistance = ::info.EyeToScreenDistance;
  info->LensSeparationDistance = ::info.LensSeparationDistance;
  info->InterpupillaryDistance = ::info.InterpupillaryDistance;
  memcpy(info->DistortionK, ::info.DistortionK, sizeof(float[4]));
  memcpy(info->ChromaAbCorrection, ::info.ChromaAbCorrection, sizeof(float[4]));
  info->DesktopX = ::info.DesktopX;
  info->DesktopY = ::info.DesktopY;
}

extern "C" void SimpleLibOVR_Orientation(Quaternion *orientation) {
  OVR::Quatf result = fusion.GetOrientation();
  orientation->x = result.x;
  orientation->y = result.y;
  orientation->z = result.z;
  orientation->w = result.w;
}
