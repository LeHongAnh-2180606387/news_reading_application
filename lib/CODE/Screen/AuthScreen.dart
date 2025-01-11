import 'package:flutter/material.dart';
import 'package:news_reading_application/CODE/GoogleSignInService.dart';
import 'package:news_reading_application/CODE/Screen/HomeScreen.dart';
//import 'package:news_reading_application/CODE/google_sign_in_service.dart';
import 'package:news_reading_application/CODE/login.dart';  // Import GoogleSignInService

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool isRegister = false;

  final GoogleSignInService _googleSignInService = GoogleSignInService();  // Khởi tạo service

  void _toggleAuthMode() {
    setState(() {
      isRegister = !isRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isRegister ? 'Đăng ký' : 'Đăng nhập'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isRegister)
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isRegister
                  ? () => registerWithEmailPassword(
                        context,
                        _emailController.text,
                        _passwordController.text,
                        _usernameController.text,
                      )
                  : () => signInWithEmailPassword(
                        context,
                        _emailController.text,
                        _passwordController.text,
                      ),
              child: Text(isRegister ? 'Đăng ký' : 'Đăng nhập'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _googleSignInService.signInWithGoogle(context),  // Gọi service từ đây
              child: Text('Đăng nhập với Google'),
            ),
            ElevatedButton(
              onPressed: () => signInAnonymously(context),  // Gọi hàm từ login.dart
              child: Text('Đăng nhập ẩn danh'),
            ),
            TextButton(
              onPressed: _toggleAuthMode,
              child: Text(isRegister ? 'Đã có tài khoản? Đăng nhập' : 'Chưa có tài khoản? Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}
