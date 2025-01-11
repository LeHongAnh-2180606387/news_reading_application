import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_reading_application/Screen/ChatScreen.dart';
import 'package:news_reading_application/Screen/ProfileScreen.dart';
import 'package:news_reading_application/Screen/AuthScreen.dart';
import 'package:news_reading_application/Screen/Dashboard.dart';
import 'package:news_reading_application/Screen/HomeScreen.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Bắt đầu quá trình đăng nhập với Google
      print("Đang tiến hành đăng nhập với Google...");
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Kiểm tra nếu người dùng hủy đăng nhập
      if (googleUser == null) {
        print("Người dùng đã hủy đăng nhập");
        return;
      }

      print("Google login thành công: ${googleUser.displayName}");

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print("Google Authentication thành công");

      // Lấy thông tin credential từ Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      print("OAuthCredential đã được tạo");

      // Đăng nhập Firebase bằng credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        print("Đăng nhập Firebase thành công: ${user.email}");

        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập Google thành công')),
        );

        // Kiểm tra xem người dùng đã tồn tại trong Firestore chưa
        final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userDoc = await userRef.get();

        if (!userDoc.exists) {
          // Nếu chưa có, lưu thông tin vào Firestore
          print("Tạo mới người dùng trong Firestore...");
          await userRef.set({
            'email': user.email,
            'username': user.displayName ?? 'Người dùng chưa đặt tên',
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else {
          print("Người dùng đã tồn tại trong Firestore.");
        }

        // Điều hướng đến trang HomeScreen sau khi đăng nhập thành công
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),//HomeScreen()),
        );
      }
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng nhập Google: $e')),
      );
    }
  }

  signOut() {}

  //_signOut(BuildContext context) {}
}

