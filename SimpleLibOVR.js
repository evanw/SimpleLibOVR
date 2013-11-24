var ffi = require('ffi');
var ref = require('ref');
var struct = require('ref-struct');

var FloatTuple4 = {
  size: ref.sizeof.float * 4,
  alignment: ref.sizeof.float,
  indirection: 1,
  get: function(buf, offset) {
    var name = 'readFloat' + ref.endianness;
    offset |= 0;
    return [
      buf[name](offset),
      buf[name](offset + ref.sizeof.float),
      buf[name](offset + ref.sizeof.float * 2),
      buf[name](offset + ref.sizeof.float * 3),
    ];
  },
};

var HMDInfo = struct({
  // Size of the entire screen, in pixels.
  HResolution: 'int',
  VResolution: 'int',

  // Physical dimensions of the active screen in meters. Can be used to calculate
  // projection center while considering IPD.
  HScreenSize: 'float',
  VScreenSize: 'float',

  // Physical offset from the top of the screen to the eye center, in meters.
  // This will usually, but not necessarily be half of VScreenSize.
  VScreenCenter: 'float',

  // Distance from the eye to screen surface, in meters.
  // Useful for calculating FOV and projection.
  EyeToScreenDistance: 'float',

  // Distance between physical lens centers useful for calculating distortion center.
  LensSeparationDistance: 'float',

  // Configured distance between the user's eye centers, in meters. Defaults to 0.064.
  InterpupillaryDistance: 'float',

  // Radial distortion correction coefficients.
  // The distortion assumes that the input texture coordinates will be scaled
  // by the following equation:
  //   uvResult = uvInput * (K0 + K1 * uvLength^2 + K2 * uvLength^4)
  // Where uvInput is the UV vector from the center of distortion in direction
  // of the mapped pixel, uvLength is the magnitude of that vector, and uvResult
  // the corresponding location after distortion.
  DistortionK: FloatTuple4,

  ChromaAbCorrection: FloatTuple4,

  // Desktop coordinate position of the screen (can be negative; may not be present on all platforms)
  DesktopX: 'int',
  DesktopY: 'int',
});

var Quaternion = struct({
  'x': 'float',
  'y': 'float',
  'z': 'float',
  'w': 'float',
});

var lib = ffi.Library('libSimpleLibOVR', {
  SimpleLibOVR_Setup: ['bool', []],
  SimpleLibOVR_Info: ['void', [ref.refType(HMDInfo)]],
  SimpleLibOVR_Orientation: ['void', [ref.refType(Quaternion)]],
});

exports.setup = function() {
  return lib.SimpleLibOVR_Setup();
};

exports.info = function() {
  var info = new HMDInfo();
  lib.SimpleLibOVR_Info(info.ref());
  info = info.toJSON();
  return info;
};

exports.orientation = function() {
  var orientation = new Quaternion();
  lib.SimpleLibOVR_Orientation(orientation.ref());
  return orientation.toJSON();
};
