import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    return const FirebaseOptions(
      apiKey: 'AIzaSyCS4Rx1s8LLmeGpFUf4INrfxFX6_KqY7dw',
      appId: 'FIREBASE_APP_ID',
      projectId: 'joveemart',
      messagingSenderId: '1036510068424',
      //authDomain: 'react-native-firebase-testing.firebaseapp.com',
      //androidClientId: '448618578101-sg12d2qin42cpr00f8b0gehs5s7inm0v.apps.googleusercontent.com',
    );
  }
}