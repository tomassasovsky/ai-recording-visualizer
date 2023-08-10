// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:ai_recording_visualizer/environments/environments.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
  static FirebaseOptions currentPlatform() {
    final projectId = environment.firebaseProjectId;
    final measurementId = environment.firebaseMeasurementId;
    final messagingSenderId = environment.firebaseMessagingSenderId;

    final web = FirebaseOptions(
      apiKey: environment.firebaseWebApiKey,
      appId: environment.firebaseWebAppId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: '$projectId.firebaseapp.com',
      storageBucket: '$projectId.appspot.com',
      measurementId: measurementId,
    );

    final android = FirebaseOptions(
      apiKey: environment.firebaseAndroidApiKey,
      appId: environment.firebaseAndroidAppId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: '$projectId.appspot.com',
    );

    final ios = FirebaseOptions(
      apiKey: environment.firebaseIosApiKey,
      appId: environment.firebaseIosAppId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: '$projectId.appspot.com',
      iosClientId: environment.firebaseIosClientId,
      iosBundleId: 'com.example.aiRecordingVisualizer',
    );

    final macos = FirebaseOptions(
      apiKey: environment.firebaseMacosApiKey,
      appId: environment.firebaseMacosAppId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: '$projectId.appspot.com',
      iosClientId: environment.firebaseMacosClientId,
      iosBundleId: 'com.example.aiRecordingVisualizer.RunnerTests',
    );

    final windows = FirebaseOptions(
      apiKey: environment.firebaseWindowsApiKey,
      appId: environment.firebaseWindowsAppId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: '$projectId.appspot.com',
    );

    final linux = FirebaseOptions(
      apiKey: environment.firebaseLinuxApiKey,
      appId: environment.firebaseLinuxAppId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: '$projectId.appspot.com',
    );

    final fuchsia = FirebaseOptions(
      apiKey: environment.firebaseFuchsiaApiKey,
      appId: environment.firebaseFuchsiaAppId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: '$projectId.appspot.com',
    );

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
        return linux;
      case TargetPlatform.fuchsia:
        return fuchsia;
    }
  }
}
