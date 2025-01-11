import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:news_reading_application/Screen/HomeScreen.dart';


class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithGitHub(BuildContext context) async {
    try {
      final String clientId = "Ov23liK38xPvFLbdwD0U";
      final String redirectUrl = "https://flutter-firebase-bc83a.firebaseapp.com/__/auth/handler";

      // Tạo URL cho GitHub OAuth
      final String url = "https://github.com/login/oauth/authorize?client_id=$clientId&scope=user:email&redirect_uri=$redirectUrl";

      // Tiến hành OAuth thông qua redirect
      final result = await FlutterWebAuth.authenticate(
        url: url,
        callbackUrlScheme: "flutter-firebase-bc83a",
      );  

      // Lấy mã code từ callback URI
      final code = Uri.parse(result).queryParameters['code'];

      // Sử dụng OAuthProvider để đăng nhập Firebase
      final OAuthCredential credential = OAuthProvider("github.com").credential(
        idToken: code,
        accessToken: code,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Đăng nhập thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công với GitHub!')),
        );
        // Điều hướng sang màn hình Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()), // Điều hướng đến màn hình Home của bạn
        );
      }
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi đăng nhập với GitHub: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _signInWithGitHub(context),
          child: Text('Đăng nhập với GitHub'),
        ),
      ),
    );
  }
}
