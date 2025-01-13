import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_reading_application/Screen/ChatScreen.dart';
import 'package:news_reading_application/Screen/Dashboard.dart';
import 'package:news_reading_application/Screen/HomeScreen.dart';
import 'package:news_reading_application/Screen/LoginPage_GitHub.dart';
import 'firebase_options.dart';
import 'package:news_reading_application/Screen/AuthScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.subscribeToTopic("all");

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(), // Đặt AuthScreen làm màn hình chính
    );
  }
}
