from ctypes import *

class HMDInfo(Structure):
  _pack_ = 1
  _fields_ = [
    # Size of the entire screen, in pixels.
    ('HResolution', c_int),
    ('VResolution', c_int),

    # Physical dimensions of the active screen in meters. Can be used to calculate
    # projection center while considering IPD.
    ('HScreenSize', c_float),
    ('VScreenSize', c_float),

    # Physical offset from the top of the screen to the eye center, in meters.
    # This will usually, but not necessarily be half of VScreenSize.
    ('VScreenCenter', c_float),

    # Distance from the eye to screen surface, in meters.
    # Useful for calculating FOV and projection.
    ('EyeToScreenDistance', c_float),

    # Distance between physical lens centers useful for calculating distortion center.
    ('LensSeparationDistance', c_float),

    # Configured distance between the user's eye centers, in meters. Defaults to 0.064.
    ('InterpupillaryDistance', c_float),

    # Radial distortion correction coefficients.
    # The distortion assumes that the input texture coordinates will be scaled
    # by the following equation:
    #   uvResult = uvInput * (K0 + K1 * uvLength^2 + K2 * uvLength^4)
    # Where uvInput is the UV vector from the center of distortion in direction
    # of the mapped pixel, uvLength is the magnitude of that vector, and uvResult
    # the corresponding location after distortion.
    ('DistortionK', c_float * 4),

    ('ChromaAbCorrection', c_float * 4),

    # Desktop coordinate position of the screen (can be negative; may not be present on all platforms)
    ('DesktopX', c_int),
    ('DesktopY', c_int),
  ]

class Quaternion(Structure):
  _pack_ = 1
  _fields_ = [
    ('x', c_float),
    ('y', c_float),
    ('z', c_float),
    ('w', c_float),
  ]

lib = cdll.LoadLibrary('libSimpleLibOVR.dylib')
lib.SimpleLibOVR_Info.argtypes = [POINTER(HMDInfo)]
lib.SimpleLibOVR_Orientation.argtypes = [POINTER(Quaternion)]

def setup():
  return True if lib.SimpleLibOVR_Setup() else False

def info():
  info = HMDInfo()
  lib.SimpleLibOVR_Info(info)
  return info

def orientation():
  orientation = Quaternion()
  lib.SimpleLibOVR_Orientation(orientation)
  return orientation
