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
    apiKey: 'AIzaSyCoDlTNkJHOaMNcpLip7yIGug908Y-ZAUw',
    appId: '1:23690210866:web:8d3aa9389eb1560540162b',
    messagingSenderId: '23690210866',
    projectId: 'flutter-firebase-bc83a',
    authDomain: 'flutter-firebase-bc83a.firebaseapp.com',
    databaseURL: 'https://flutter-firebase-bc83a-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-firebase-bc83a.firebasestorage.app',
    measurementId: 'G-2B94LW639K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMPT4No3mhmpHb0FEDpPnHDWzw4sCpI_o',
    appId: '1:23690210866:android:b55507fccefa280940162b',
    messagingSenderId: '23690210866',
    projectId: 'flutter-firebase-bc83a',
    databaseURL: 'https://flutter-firebase-bc83a-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-firebase-bc83a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDu3R2moIxXLIwh4wizyOnDPi2YFTAJkwA',
    appId: '1:23690210866:ios:95724567d35bf5ee40162b',
    messagingSenderId: '23690210866',
    projectId: 'flutter-firebase-bc83a',
    databaseURL: 'https://flutter-firebase-bc83a-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-firebase-bc83a.firebasestorage.app',
    iosClientId: '23690210866-t5mh76ftcqjpp320mkd0ihjfqr216m18.apps.googleusercontent.com',
    iosBundleId: 'com.example.newsReadingApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDu3R2moIxXLIwh4wizyOnDPi2YFTAJkwA',
    appId: '1:23690210866:ios:95724567d35bf5ee40162b',
    messagingSenderId: '23690210866',
    projectId: 'flutter-firebase-bc83a',
    databaseURL: 'https://flutter-firebase-bc83a-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-firebase-bc83a.firebasestorage.app',
    iosClientId: '23690210866-t5mh76ftcqjpp320mkd0ihjfqr216m18.apps.googleusercontent.com',
    iosBundleId: 'com.example.newsReadingApplication',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCoDlTNkJHOaMNcpLip7yIGug908Y-ZAUw',
    appId: '1:23690210866:web:39f5d45d4a1e076040162b',
    messagingSenderId: '23690210866',
    projectId: 'flutter-firebase-bc83a',
    authDomain: 'flutter-firebase-bc83a.firebaseapp.com',
    databaseURL: 'https://flutter-firebase-bc83a-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-firebase-bc83a.firebasestorage.app',
    measurementId: 'G-E6RTN66BWE',
  );
}
