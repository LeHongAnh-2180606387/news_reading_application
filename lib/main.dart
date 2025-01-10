import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_reading_application/screen/login_screen.dart';
import 'package:news_reading_application/screen/registration_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (context) => const LoginScreen(),
          'register': (context) => const RegistrationScreen(),
        }),
  );
}
