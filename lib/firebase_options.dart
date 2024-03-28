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
    apiKey: 'AIzaSyCD3fW4hd1ZA9hCxlRULPvMTB1FRvBHmj4',
    appId: '1:697379911538:web:711c18f2afe428043ccfeb',
    messagingSenderId: '697379911538',
    projectId: 'glob-ba766',
    authDomain: 'glob-ba766.firebaseapp.com',
    storageBucket: 'glob-ba766.appspot.com',
    measurementId: 'G-MMH1JRVJ48',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8S74oaATwd1Rf589-MWghWDrIQVoPbfY',
    appId: '1:697379911538:android:ac1a27df61b24c803ccfeb',
    messagingSenderId: '697379911538',
    projectId: 'glob-ba766',
    storageBucket: 'glob-ba766.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHHwdgQnNwkNoB18NrsM2t8B0KBFE_DH8',
    appId: '1:697379911538:ios:c41661ef919526b03ccfeb',
    messagingSenderId: '697379911538',
    projectId: 'glob-ba766',
    storageBucket: 'glob-ba766.appspot.com',
    androidClientId: '697379911538-pclugftb1p7jropkmt2nkh6i536o0b1c.apps.googleusercontent.com',
    iosClientId: '697379911538-t9rkeoecef0ch6o42vm6m4jhvhem67it.apps.googleusercontent.com',
    iosBundleId: 'com.example.untitled',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHHwdgQnNwkNoB18NrsM2t8B0KBFE_DH8',
    appId: '1:697379911538:ios:e376f82113f182943ccfeb',
    messagingSenderId: '697379911538',
    projectId: 'glob-ba766',
    storageBucket: 'glob-ba766.appspot.com',
    androidClientId: '697379911538-pclugftb1p7jropkmt2nkh6i536o0b1c.apps.googleusercontent.com',
    iosClientId: '697379911538-4agclp3t8vhq8ovokf81t4q8f3lbsfmi.apps.googleusercontent.com',
    iosBundleId: 'com.example.untitled.RunnerTests',
  );
}
