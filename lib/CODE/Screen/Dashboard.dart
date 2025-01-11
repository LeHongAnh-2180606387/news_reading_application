import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_reading_application/CODE/Article.dart';
import 'package:news_reading_application/CODE/Chat/Screen/ChatScreen.dart';
import 'package:news_reading_application/CODE/Profile/ProfileScreen.dart';
import 'package:news_reading_application/CODE/Screen/AuthScreen.dart';
import 'package:news_reading_application/CODE/Screen/HomeScreen.dart';
import 'package:news_reading_application/CODE/Search.dart';
import 'package:news_reading_application/CODE/weather_service.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;  // Lưu chỉ số màn hình hiện tại
  bool _isLoggedIn = false;  // Biến kiểm tra trạng thái đăng nhập
  String _query = '';  // Chuỗi tìm kiếm hiện tại
  List<Article> _searchResults = [];  // Kết quả tìm kiếm
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
    if (user != null) {
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  // Xử lý khi chọn tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Cập nhật chỉ số của màn hình hiện tại
    });
  }

  // Hàm thực hiện tìm kiếm
  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    // Tìm kiếm bài viết
    List<Article> results = await searchArticles(query);

    setState(() {
      _isLoading = false;
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Tìm kiếm...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _query = value;
            });
            if (_query.isNotEmpty) {
              _performSearch(_query);  // Thực hiện tìm kiếm mỗi khi người dùng nhập
            } else {
              setState(() {
                _searchResults = [];  // Nếu không có tìm kiếm, xóa kết quả
              });
            }
          },
          onSubmitted: (value) {
            _performSearch(value);  // Tìm kiếm khi người dùng nhấn Enter
          },
        ),
      ),
      body: _isLoggedIn
          ? (_query.isEmpty
              ? _screens[_selectedIndex]  // Hiển thị màn hình tương ứng nếu không có tìm kiếm
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_searchResults[index].title),
                      subtitle: Text(_searchResults[index].summary),
                      onTap: () {
                        // Mở bài viết chi tiết khi người dùng chọn
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailScreen(article: _searchResults[index])));
                      },
                    );
                  },
                ))
          : Center(child: CircularProgressIndicator()),  // Hiển thị khi đang tải
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
