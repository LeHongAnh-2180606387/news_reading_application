import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_reading_application/CODE/Screen/AuthScreen.dart';
import 'package:news_reading_application/CODE/Screen/HomeScreen.dart';
import 'package:news_reading_application/CODE/Chat/Screen/ChatScreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  String _username = 'Anonymous';
  String _email = '';
  String _photoURL = ''; // Lưu URL của ảnh đại diện

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _getUserData();
  }

  // Lấy thông tin người dùng từ Firestore
  Future<void> _getUserData() async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(_user.uid);
      final userDoc = await userRef.get();
      
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'] ?? 'Anonymous';
          _email = userDoc['email'] ?? '';
          
          // Kiểm tra nếu người dùng không đăng nhập qua Google và không có photoURL
          if (_user.photoURL != null && _user.photoURL!.isNotEmpty) {
            _photoURL = _user.photoURL!; // Nếu có ảnh từ Google, dùng ảnh đó
          } else {
            _photoURL = 'assets/images/Default.jpg'; // Dùng ảnh mặc định nếu không có ảnh từ Google
          }
        });
      }
    } catch (e) {
      print('Lỗi lấy thông tin người dùng: $e');
    }
  }

  // Đăng xuất người dùng
  Future<void> _logout() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut(); // Đăng xuất khỏi Google
    await FirebaseAuth.instance.signOut(); // Đăng xuất khỏi Firebase
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()), // Quay lại màn hình AuthScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center( // Dùng Center widget để căn giữa toàn bộ body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo trục dọc
            crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo trục ngang
            children: [
              // Avatar
              CircleAvatar(
                radius: 60,
                backgroundImage: _photoURL.startsWith('http') 
                  ? NetworkImage(_photoURL) // Nếu có URL hình ảnh, sử dụng NetworkImage
                  : AssetImage(_photoURL) as ImageProvider, // Nếu không có ảnh URL, dùng ảnh mặc định
              ),
              SizedBox(height: 16),
              // Tên người dùng
              Text(
                _username,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              // Email người dùng
              Text(
                _email,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              // Nút Đăng xuất
              ElevatedButton(
                onPressed: _logout,
                child: Text('Đăng xuất'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

