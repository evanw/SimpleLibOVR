# SimpleLibOVR

A simple C wrapper for the messy C++ Oculus Rift API so the orientation information can be used easily by other languages.
Provides additional wrappers for C#, JavaScript, and Python.
The API consists of three functions, demonstrated in JavaScript below:

    var libOVR = require('./SimpleLibOVR');
    if (!libOVR.setup()) throw new Error('Could not connect to Oculus Rift');
    console.log(libOVR.info());
    setInterval(function() { console.log(libOVR.orientation()); }, 1000);

Note that using the C# wrapper on OS X with Mono requires the use of a config file named YourApp.exe.config and placed in the same folder as YourApp.exe:

    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
      <dllmap dll="SimpleLibOVR" target="libSimpleLibOVR.dylib" />
    </configuration>

Right now building only works with OS X, which is done by running "make".
