
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyAhSwEy6AGetkclb7XX6G_5aLLxua_sdPw',
    appId: '1:618749503113:web:568277fc2a40398c4ec858',
    messagingSenderId: '618749503113',
    projectId: 'telecare-doctor-task-2026',
    authDomain: 'telecare-doctor-task-2026.firebaseapp.com',
    storageBucket: 'telecare-doctor-task-2026.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCsj9gBnkpbTFVu6A1G3A1qsTrm0gHYQvo',
    appId: '1:793134205271:android:7da36fff29926533869612',
    messagingSenderId: '793134205271',
    projectId: 'telecare-app-2026-3815-76001',
    storageBucket: 'telecare-app-2026-3815-76001.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOOiXuyrAkG8nfoTimuLP2dlivgqkR0Qo',
    appId: '1:793134205271:ios:d1efb1a1662a9907869612',
    messagingSenderId: '793134205271',
    projectId: 'telecare-app-2026-3815-76001',
    storageBucket: 'telecare-app-2026-3815-76001.firebasestorage.app',
    iosBundleId: 'com.hasan.telecare.doctor',
  );
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-AYZiT4y7pQruF0ubdtcB5cE64OcDbUI',
    appId: '1:618749503113:ios:f37c6098b7a533114ec858',
    messagingSenderId: '618749503113',
    projectId: 'telecare-doctor-task-2026',
    storageBucket: 'telecare-doctor-task-2026.firebasestorage.app',
    iosBundleId: 'com.example.telecareDoctorApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAhSwEy6AGetkclb7XX6G_5aLLxua_sdPw',
    appId: '1:618749503113:web:a25326189bcc3e5c4ec858',
    messagingSenderId: '618749503113',
    projectId: 'telecare-doctor-task-2026',
    authDomain: 'telecare-doctor-task-2026.firebaseapp.com',
    storageBucket: 'telecare-doctor-task-2026.firebasestorage.app',
  );
}
