import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Web platform is not supported in this version.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDy5SRbVDksn1Bdvu8_cUdFe10d3qy58jg',
    appId: '1:295605640328:android:e0b9157a0bac6f5dcb133d',
    messagingSenderId: '295605640328',
    projectId: 'mikai-9ca25',
    storageBucket: 'mikai-9ca25.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnb9rGXHYHpDlpzItjRgi0BZz12u7dHQ4',
    appId: '1:295605640328:ios:4f13b0572988e000cb133d',
    messagingSenderId: '295605640328',
    projectId: 'mikai-9ca25',
    storageBucket: 'mikai-9ca25.firebasestorage.app',
    iosClientId: '295605640328-ios-4f13b0572988e000cb133d',
    iosBundleId: 'com.mikai.materialordersapp',
  );
} 