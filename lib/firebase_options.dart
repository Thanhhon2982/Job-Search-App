// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyB3PmJwOpbsspf9mfwPg2A0PaEtPD9Xvc8',
    appId: '1:403234887741:web:94e918f07a22fa6105b254',
    messagingSenderId: '403234887741',
    projectId: 'jobapp-2fbca',
    authDomain: 'jobapp-2fbca.firebaseapp.com',
    storageBucket: 'jobapp-2fbca.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_4rJhbMd_IvKHuVTWygdk5MbEyscZFL8',
    appId: '1:403234887741:android:2faefa6e8ae6ef1d05b254',
    messagingSenderId: '403234887741',
    projectId: 'jobapp-2fbca',
    storageBucket: 'jobapp-2fbca.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCGKniw8R22lcaRWnHHgIC1SE2NNzyjdA0',
    appId: '1:403234887741:ios:f76a274c4fad976105b254',
    messagingSenderId: '403234887741',
    projectId: 'jobapp-2fbca',
    storageBucket: 'jobapp-2fbca.appspot.com',
    iosBundleId: 'com.example.myFlutterApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCGKniw8R22lcaRWnHHgIC1SE2NNzyjdA0',
    appId: '1:403234887741:ios:f76a274c4fad976105b254',
    messagingSenderId: '403234887741',
    projectId: 'jobapp-2fbca',
    storageBucket: 'jobapp-2fbca.appspot.com',
    iosBundleId: 'com.example.myFlutterApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB3PmJwOpbsspf9mfwPg2A0PaEtPD9Xvc8',
    appId: '1:403234887741:web:6e16cbc30a130b9e05b254',
    messagingSenderId: '403234887741',
    projectId: 'jobapp-2fbca',
    authDomain: 'jobapp-2fbca.firebaseapp.com',
    storageBucket: 'jobapp-2fbca.appspot.com',
  );
}
