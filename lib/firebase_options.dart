// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAgu3xENxF8a9ej9MYxhmnDhUdYFMOpfXQ',
    appId: '1:622115718239:web:ab5202cd100f04ae4347ea',
    messagingSenderId: '622115718239',
    projectId: 'instagram-clone-macas',
    authDomain: 'instagram-clone-macas.firebaseapp.com',
    storageBucket: 'instagram-clone-macas.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCqazlZjweE7sL_DCuOyyRBIc43Cr0iOiw',
    appId: '1:622115718239:android:dbcf317a40c535794347ea',
    messagingSenderId: '622115718239',
    projectId: 'instagram-clone-macas',
    storageBucket: 'instagram-clone-macas.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVNb0_5Yy3MtkEdo-nWZY4H_isO9gANTU',
    appId: '1:622115718239:ios:ed6229fd4b7d82ae4347ea',
    messagingSenderId: '622115718239',
    projectId: 'instagram-clone-macas',
    storageBucket: 'instagram-clone-macas.appspot.com',
    iosBundleId: 'com.macas.igclone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCVNb0_5Yy3MtkEdo-nWZY4H_isO9gANTU',
    appId: '1:622115718239:ios:372e3fcd426d80694347ea',
    messagingSenderId: '622115718239',
    projectId: 'instagram-clone-macas',
    storageBucket: 'instagram-clone-macas.appspot.com',
    iosBundleId: 'com.macas.igclone.RunnerTests',
  );
}
