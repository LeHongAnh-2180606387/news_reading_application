import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_reading_application/Screen/ChatScreen.dart';
import 'package:news_reading_application/Screen/Dashboard.dart';
import 'package:news_reading_application/Screen/HomeScreen.dart';
import 'package:news_reading_application/Screen/LoginPage_GitHub.dart';
import 'package:news_reading_application/Screen/SearchScreen.dart';
import 'firebase_options.dart';
import 'package:news_reading_application/Screen/AuthScreen.dart';
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
  // return MaterialApp(
  //     title: 'Flutter Chat',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //     ),
  //     home: StreamBuilder(
  //       stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: (ctx, userSnapshot) {
  //         if (userSnapshot.hasData) {
  //           return const ChatScreen();
  //         }
  //         return Scaffold(
  //           body: Center(
  //             child: ElevatedButton(
  //               child: const Text('Đăng nhập ẩn danh'),
  //               onPressed: () async {
  //                 await FirebaseAuth.instance.signInAnonymously();
  //               },
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}