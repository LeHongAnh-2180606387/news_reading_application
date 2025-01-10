import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_reading_application/CODE/Screen/HomeScreen.dart';

Future<void> registerWithEmailPassword(String email, String password, String username) async {
  try {
    // Đăng ký tài khoản người dùng với email và mật khẩu
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Lưu thông tin người dùng vào Firestore
    await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
      'username': username,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'photoURL': userCredential.user?.photoURL, // Lưu ảnh đại diện nếu có
    });

    print("Tạo tài khoản thành công!");
  } catch (e) {
    print('Lỗi đăng ký: $e');
    throw Exception("Đăng ký thất bại: $e");  // Thông báo lỗi cho người dùng
  }
}

Future<User?> signInWithEmailPassword(BuildContext context, String email, String password) async {
  try {
    // Đăng nhập với email và mật khẩu
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Nếu đăng nhập thành công, hiển thị thông báo bằng SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Đăng nhập thành công: ${userCredential.user?.email}"),
        duration: Duration(seconds: 2), // Thời gian hiển thị SnackBar
      ),
    );

    // Chuyển đến HomeScreen sau khi đăng nhập thành công
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()), // HomeScreen là màn hình bạn muốn chuyển tới
    );

    return userCredential.user;
  } catch (e) {
    // Nếu có lỗi đăng nhập, hiển thị thông báo lỗi bằng SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Không có tài khoản hoặc đã sai email hoặc đã sai mật khẩu $e"),
        duration: Duration(seconds: 3), // Thời gian hiển thị SnackBar
      ),
    );

    // Không làm ứng dụng "đứng", chỉ thông báo lỗi cho người dùng
    return null;  // Trả về null nếu đăng nhập thất bại
  }
}


