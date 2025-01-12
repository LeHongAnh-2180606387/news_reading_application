import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:news_reading_application/Screen/HomeScreen.dart';
import 'package:news_reading_application/Screen/ChatScreen.dart';
import 'package:news_reading_application/Screen/ProfileScreen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;  // Lưu chỉ số màn hình hiện tại
  bool _isLoggedIn = false;  // Biến kiểm tra trạng thái đăng nhập
  bool _isLoading = false;  // Biến kiểm tra trạng thái loading

  // Danh sách các màn hình
  final List<Widget> _screens = [
    HomeScreen(), // HomeScreen
    ChatScreen(), // Community Screen
    ProfileScreen(), // Profile Screen
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();  // Kiểm tra trạng thái đăng nhập
  }

  // Kiểm tra trạng thái đăng nhập
  void _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _isLoggedIn = user != null;
    });
  }

  // Xử lý khi chọn tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Cập nhật chỉ số của màn hình hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedIndex].toString()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())  // Hiển thị khi đang tải
          : _screens[_selectedIndex],  // Hiển thị màn hình tương ứng
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,  // Khi chọn tab, chuyển sang màn hình tương ứng
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
