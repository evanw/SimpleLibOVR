using System;
using System.Runtime.InteropServices;

[StructLayout(LayoutKind.Sequential, Pack = 1)]
public class HMDInfo
{
  // Size of the entire screen, in pixels.
  public int HResolution, VResolution;

  // Physical dimensions of the active screen in meters. Can be used to calculate
  // projection center while considering IPD.
  public float HScreenSize, VScreenSize;

  // Physical offset from the top of the screen to the eye center, in meters.
  // This will usually, but not necessarily be half of VScreenSize.
  public float VScreenCenter;

  // Distance from the eye to screen surface, in meters.
  // Useful for calculating FOV and projection.
  public float EyeToScreenDistance;

  // Distance between physical lens centers useful for calculating distortion center.
  public float LensSeparationDistance;

  // Configured distance between the user's eye centers, in meters. Defaults to 0.064.
  public float InterpupillaryDistance;

  // Radial distortion correction coefficients.
  // The distortion assumes that the input texture coordinates will be scaled
  // by the following equation:
  //   uvResult = uvInput * (K0 + K1 * uvLength^2 + K2 * uvLength^4)
  // Where uvInput is the UV vector from the center of distortion in direction
  // of the mapped pixel, uvLength is the magnitude of that vector, and uvResult
  // the corresponding location after distortion.
  [MarshalAs(UnmanagedType.ByValArray, SizeConst = 4)]
  public float[] DistortionK;

  [MarshalAs(UnmanagedType.ByValArray, SizeConst = 4)]
  public float[] ChromaAbCorrection;

  // Desktop coordinate position of the screen (can be negative; may not be present on all platforms)
  public int DesktopX, DesktopY;
}

[StructLayout(LayoutKind.Sequential, Pack = 1)]
public class Quaternion
{
  public float X, Y, Z, W;
}

public class SimpleLibOVR
{
  [DllImport("SimpleLibOVR")]
  private static extern bool SimpleLibOVR_Setup();

  [DllImport("SimpleLibOVR")]
  private static extern void SimpleLibOVR_Info([In, MarshalAs(UnmanagedType.LPStruct)] HMDInfo info);

  [DllImport("SimpleLibOVR")]
  private static extern void SimpleLibOVR_Orientation([In, MarshalAs(UnmanagedType.LPStruct)] Quaternion orientation);

  public static bool Setup() {
    return SimpleLibOVR_Setup();
  }

  public static HMDInfo Info() {
    HMDInfo info = new HMDInfo();
    SimpleLibOVR_Info(info);
    return info;
  }

  public static Quaternion Orientation() {
    Quaternion orientation = new Quaternion();
    SimpleLibOVR_Orientation(orientation);
    return orientation;
  }
}
