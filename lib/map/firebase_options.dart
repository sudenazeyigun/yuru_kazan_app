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
    apiKey: 'AIzaSyD6kmZJ_Y5adzq_rQvslT4xINdiWMCFbuM',
    appId: '1:549626923649:web:364149afc136bcfc2c5b80',
    messagingSenderId: '549626923649',
    projectId: 'yuru-kazan-app',
    authDomain: 'yuru-kazan-app.firebaseapp.com',
    storageBucket: 'yuru-kazan-app.appspot.com',
    measurementId: 'G-PMXYFV5PTG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqwZjQjN87wsfCf1SOEzAPnKZulu_XctE',
    appId: '1:549626923649:android:960d968ba9aeadc22c5b80',
    messagingSenderId: '549626923649',
    projectId: 'yuru-kazan-app',
    storageBucket: 'yuru-kazan-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDF_0dkqOMLsE7njBNQqCOwiLMinPwJlxk',
    appId: '1:549626923649:ios:6fe34dca2c41c8c42c5b80',
    messagingSenderId: '549626923649',
    projectId: 'yuru-kazan-app',
    storageBucket: 'yuru-kazan-app.appspot.com',
    iosClientId: '549626923649-asjcef5nlulbe9tmktii6qnnf5en37o8.apps.googleusercontent.com',
    iosBundleId: 'com.example.yuruKazanApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDF_0dkqOMLsE7njBNQqCOwiLMinPwJlxk',
    appId: '1:549626923649:ios:6fe34dca2c41c8c42c5b80',
    messagingSenderId: '549626923649',
    projectId: 'yuru-kazan-app',
    storageBucket: 'yuru-kazan-app.appspot.com',
    iosClientId: '549626923649-asjcef5nlulbe9tmktii6qnnf5en37o8.apps.googleusercontent.com',
    iosBundleId: 'com.example.yuruKazanApp',
  );
}