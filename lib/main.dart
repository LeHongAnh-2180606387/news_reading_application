import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_reading_application/CODE/Screen/HomeScreen.dart';
import 'package:news_reading_application/CODE/Screen/LoginPage.dart';
import 'package:news_reading_application/CODE/Screen/SearchScreen.dart';
import 'firebase_options.dart';
import 'package:news_reading_application/CODE/Screen/AuthScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
