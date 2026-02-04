// File generated for Firebase configuration
// Project: pinterest-clone-46b9f

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
          'DefaultFirebaseOptions have not been configured for windows.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB1auwplntWkx2-eYed-yMP4QNm_YCul40',
    appId: '1:102111135430:web:175134e4728f798e01f9c7',
    messagingSenderId: '102111135430',
    projectId: 'pinterest-clone-46b9f',
    authDomain: 'pinterest-clone-46b9f.firebaseapp.com',
    storageBucket: 'pinterest-clone-46b9f.firebasestorage.app',
    measurementId: 'G-VZR7LLE7B4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB1auwplntWkx2-eYed-yMP4QNm_YCul40',
    appId: '1:102111135430:android:642422ae8b18ecdb01f9c7',
    messagingSenderId: '102111135430',
    projectId: 'pinterest-clone-46b9f',
    storageBucket: 'pinterest-clone-46b9f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB1auwplntWkx2-eYed-yMP4QNm_YCul40',
    appId: '1:102111135430:ios:642422ae8b18ecdb01f9c7',
    messagingSenderId: '102111135430',
    projectId: 'pinterest-clone-46b9f',
    storageBucket: 'pinterest-clone-46b9f.firebasestorage.app',
    iosBundleId: 'com.galaxy.pinterestClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB1auwplntWkx2-eYed-yMP4QNm_YCul40',
    appId: '1:102111135430:ios:642422ae8b18ecdb01f9c7',
    messagingSenderId: '102111135430',
    projectId: 'pinterest-clone-46b9f',
    storageBucket: 'pinterest-clone-46b9f.firebasestorage.app',
    iosBundleId: 'com.galaxy.pinterestClone',
  );
}
