import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';  
import 'package:news_reading_application/CODE/Screen/AuthScreen.dart';
import 'package:news_reading_application/CODE/weather_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String weatherAnimation = ''; 
  bool isLoading = true;
  bool isLoggedIn = false; // Biến trạng thái đăng nhập
  GoogleSignInAccount? _user;

  @override
  void initState() {
    super.initState();
    _loadWeather();
    _checkLoginStatus();
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
                )
              ,
        ],
      ),
      body: Row(
        children: [
          isLoading
              ? CircularProgressIndicator()  // Hiển thị loading khi đang tải
              : weatherAnimation.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 50.0),  
                      child: Lottie.asset(
                        weatherAnimation,  // Hiển thị animation từ file JSON
                        width: 50,
                        height: 50,
                      ),
                    )
                  : Text('Không thể lấy dữ liệu thời tiết'),
        ],
      ),
    );
  }
}
