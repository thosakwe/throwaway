import 'dart:io';

// Denying filesystem access to untrusted code.
//
// Replace `unsafeMain` with the `main` imported from the untrusted file.
// Then, start this script in a separate Isolate.
//
// This does not prevent the use of native extensions.
// True sandboxing of Dart code requires deeper analysis.
main() {
  _s([_, __, ___]) => throw UnsupportedError('lol access denied dweeb');
  return IOOverrides.runZoned(
    unsafeMain,
    createDirectory: _s,
    getCurrentDirectory: _s,
    getSystemTempDirectory: _s,
    setCurrentDirectory: _s,
    createFile: _s,
    fseGetType: _s,
    fseIdentical: _s,
    fseIdenticalSync: _s,
    fsWatch: _s,
    fsWatchIsSupported: _s,
    stat: _s,
    statSync: _s,
    createLink: _s,
  );
}

unsafeMain() async {
  var file = File.fromUri(Platform.script);
  print(file.path);
  print(await file.exists());
}
