import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:news_reading_application/CODE/Service/Article_Service.dart';  
import 'package:news_reading_application/Screen/AuthScreen.dart';
import 'package:news_reading_application/CODE/Service/weather_service.dart';
import 'package:news_reading_application/Screen/CreateArticleScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String weatherAnimation = ''; 
  bool isLoading = true;
  bool isLoggedIn = false; // Biến trạng thái đăng nhập
  GoogleSignInAccount? _user;
  List<Map<String, dynamic>> articles = []; // Danh sách bài báo

  final ArticleService _articleService = ArticleService(); // Khởi tạo ArticleService

  @override
  void initState() {
    super.initState();
    _loadWeather();
    _checkLoginStatus();
    _loadArticles();
  }

  // Kiểm tra trạng thái đăng nhập
  Future<void> _checkLoginStatus() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    _user = _googleSignIn.currentUser;

    setState(() {
      isLoggedIn = _user != null;  // Kiểm tra nếu có user tức là đã đăng nhập
    });
  }

  Future<void> _signIn() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  try {
    await _googleSignIn.signIn();
    // Cập nhật trạng thái sau khi đăng nhập
    _checkLoginStatus();

    // Sau khi đăng nhập thành công, chuyển đến AuthScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()), // Chuyển đến màn hình đăng nhập
    );
  } catch (e) {
    print('Đăng nhập thất bại: $e');
  }
}

  // Đăng xuất
  Future<void> _signOut(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut(); // Đăng xuất khỏi Google
    await FirebaseAuth.instance.signOut(); // Đăng xuất khỏi Firebase
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()), // Quay lại màn hình AuthScreen
    );
  }

  Future<void> _loadWeather() async {
  try {
    // Lấy vị trí người dùng
    Position position = await getUserLocation();
    double lat = position.latitude;
    double lon = position.longitude;

    // Lấy mã icon thời tiết
    String iconCode = await fetchWeatherIcon(lat, lon);

    if (mounted) {
      setState(() {
        weatherAnimation = getWeatherAnimation(iconCode);  // Gọi hàm để lấy đường dẫn file JSON cho animation
        isLoading = false;
      });
    }
  } catch (e) {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    print(e);
  }
}

// Lấy bài báo từ Firestore
  Future<void> _loadArticles() async {
    List<Map<String, dynamic>> fetchedArticles = await _articleService.fetchArticles();
    setState(() {
      articles = fetchedArticles;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang Chủ'),
        actions: [
          isLoggedIn
              ? IconButton(
                  icon: Icon(Icons.login),
                  onPressed: _signIn,  // Nếu chưa đăng nhập, hiện icon đăng nhập
                )
              : IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => _signOut(context),  // Nếu đã đăng nhập, hiện icon đăng xuất
                ),
        ],
      ),
      body: Column(  // Thay Row thành Column để các phần tử nằm theo chiều dọc
        children: [
        // Hiển thị biểu tượng thời tiết, nằm dưới AppBar và căn trái
          isLoading
              ? CircularProgressIndicator()  // Hiển thị loading khi đang tải
              : weatherAnimation.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0),  // Thêm khoảng cách từ trên xuống
                      child: Align(
                        alignment: Alignment.centerLeft,  // Căn trái icon
                        child: Lottie.asset(
                          weatherAnimation,  // Hiển thị animation từ file JSON
                          width: 50,
                          height: 50,
                        ),
                      ),
                    )
                  : Text('Không thể lấy dữ liệu thời tiết'),
                  SizedBox(height: 20),  // Khoảng cách 20 đơn vị
          // Danh sách bài báo
          Expanded(
            child: articles.isEmpty
                ? Center(child: CircularProgressIndicator()) // Nếu chưa có bài báo
                : ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      String imageUrl = articles[index]['imageUrl'] ?? '';
                      String title = articles[index]['title'] ?? 'Không có tiêu đề';
                      return ListTile(
                        leading: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                            : Icon(Icons.image_not_supported),
                        title: Text(title),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateArticleScreen()), // Chuyển đến màn hình tạo bài báo
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Tạo bài báo mới',
      ),
    );
  }
}
