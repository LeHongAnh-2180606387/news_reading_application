import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:news_reading_application/CODE/Service/weather_service.dart';
import 'package:news_reading_application/Screen/AuthScreen.dart';
import 'package:news_reading_application/Screen/NewsSearchDelegate.dart';
import 'package:news_reading_application/Screen/bookmark_screen.dart';

import 'package:news_reading_application/Screen/news_webview.dart';

import 'package:news_reading_application/CODE/Service/SearchService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey =
      'bff42077feb94c4eaeafbc0891768e33'; // Replace with your News API key
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  List<dynamic> newsArticles = [];
  List<dynamic> bookmarkedArticles = []; // To store bookmarked articles
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> categoryKeys = {};
  // Tìm kiếm
  final SearchService _searchService = SearchService();
  List<Map<String, dynamic>> searchResults = []; // Danh sách kết quả tìm kiếm
  TextEditingController searchController =
      TextEditingController(); // Controller tìm kiếm

  // String weatherAnimation = ''; // Animation for weather
  String weatherAnimation = ''; // Animation for weather
  //bool isLoggedIn = false; // Biến trạng thái đăng nhập
  GoogleSignInAccount? _user;

  // Categories and selected category
  List<String> categories = [
    'All',
    'Business',
    'Entertainment',
    'Health',
    'Science',
    'Sports',
    'Technology'
  ];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    for (var category in categories) {
      categoryKeys[category] = GlobalKey();
    }
    _loadWeather();
    _checkLoginStatus();
    fetchNews(); // Fetch initial news
  }

// Kiểm tra trạng thái đăng nhập
  Future<void> _checkLoginStatus() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    _user = _googleSignIn.currentUser;
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
        MaterialPageRoute(
            builder: (context) =>
                AuthScreen()), // Chuyển đến màn hình đăng nhập
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
      MaterialPageRoute(
          builder: (context) => AuthScreen()), // Quay lại màn hình AuthScreen
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
          weatherAnimation = getWeatherAnimation(
              iconCode); // Gọi hàm để lấy đường dẫn file JSON cho animation
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

  Future<void> fetchNews({String? category, String? query}) async {
    if (!mounted) return; // Check if widget is still mounted
    setState(() {
      isLoading = true;
    });

    try {
      String url = '$baseUrl?country=us&apiKey=$apiKey';
      if (category != null && category != 'All') {
        url += '&category=${category.toLowerCase()}';
      }
      if (query != null && query.isNotEmpty) {
        url += '&q=$query';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!mounted) return; // Check again before updating state
        setState(() {
          newsArticles = data['articles'];
          isLoading = false;
        });

        // Store each article in Firestore
        for (var article in data['articles']) {
          await FirebaseFirestore.instance.collection('articles').add({
            'title': article['title'],
            'description': article['description'],
            'url': article['url'],
            'urlToImage': article['urlToImage'],
            'publishedAt': article['publishedAt'],
          });
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print('Error fetching news: $error');
      if (!mounted) return; // Check again before updating state
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hàm thực hiện tìm kiếm
  Future<void> _performSearch(String query) async {
    if (query.isNotEmpty) {
      var results = await _searchService.searchArticles(query);
      setState(() {
        searchResults = results;
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  final Map<String, String> categoryImages = {
    'business': 'assets/images/business.jpg',
    'entertainment': 'assets/images/entertainment.jpg',
    'health': 'assets/images/health.jpg',
    'science': 'assets/images/science.jpg',
    'sports': 'assets/images/sports.jpg',
    'technology': 'assets/images/technology.jpg',
  };

  void toggleBookmark(dynamic article) {
    setState(() {
      if (bookmarkedArticles.contains(article)) {
        bookmarkedArticles.remove(article);
      } else {
        bookmarkedArticles.add(article);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BookmarkScreen(bookmarkedArticles: bookmarkedArticles),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NewsSearchDelegate(
                  searchService: _searchService,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 174, 191, 199),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Weather Animation
                  weatherAnimation.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Lottie.asset(
                              weatherAnimation,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        )
                      : const Text('Không thể lấy dữ liệu thời tiết'),

                  const SizedBox(height: 20),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController, // Gắn ScrollController
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 10.0),
                      child: Row(
                        children: categories.map((category) {
                          final String imageUrl = categoryImages[
                                  category.toLowerCase()] ??
                              'assets/images/default.jpg'; // Ảnh mặc định nếu không tìm thấy

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                  fetchNews(
                                      category:
                                          category); // Fetch news for selected category
                                });

                                // Lấy vị trí của thẻ trong ScrollView
                                final key = categoryKeys[category];
                                final RenderBox? box = key?.currentContext
                                    ?.findRenderObject() as RenderBox?;
                                final double? position =
                                    box?.localToGlobal(Offset.zero).dx;

                                if (position != null) {
                                  // Cuộn đến vị trí
                                  _scrollController.animateTo(
                                    _scrollController.offset +
                                        position -
                                        MediaQuery.of(context).size.width / 2 +
                                        60, // Đưa thẻ vào giữa màn hình
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Thẻ chính với hình nền
                                  Container(
                                    key: categoryKeys[
                                        category], // Gắn GlobalKey cho từng category
                                    width: 120,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage(imageUrl), // Ảnh nền
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Lớp phủ màu khi chọn
                                  Container(
                                    width: 120,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedCategory == category
                                          ? Colors.black.withOpacity(0.6)
                                          : Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                  // Văn bản ở trung tâm
                                  Text(
                                    category[0].toUpperCase() +
                                        category.substring(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Dấu tích khi chọn
                                  if (selectedCategory == category)
                                    const Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.greenAccent,
                                        size: 24,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Kết quả tìm kiếm
                  Expanded(
                    child: searchResults.isEmpty
                        ? ListView.builder(
                            itemCount: newsArticles.length,
                            itemBuilder: (context, index) {
                              final article = newsArticles[index];
                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (article['urlToImage'] != null)
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(12.0),
                                        ),
                                        child: Image.network(
                                          article['urlToImage'],
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Tiêu đề bài viết
                                          Text(
                                            article['title'] ?? 'No Title',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          // Mô tả bài viết
                                          Text(
                                            article['description'] ??
                                                'No Description',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebViewScreen(
                                                    url: article['url'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text("Read More"),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              bookmarkedArticles
                                                      .contains(article)
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,
                                              color: bookmarkedArticles
                                                      .contains(article)
                                                  ? Colors.red
                                                  : null,
                                            ),
                                            onPressed: () {
                                              toggleBookmark(article);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final article = searchResults[index];
                              return Card(
                                margin: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (article['urlToImage'] != null)
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(12.0),
                                        ),
                                        child: Image.network(
                                          article['urlToImage'],
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article['title'] ?? 'No Title',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            article['description'] ??
                                                'No Description',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebViewScreen(
                                                    url: article['url'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text("Read More"),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              bookmarkedArticles
                                                      .contains(article)
                                                  ? Icons.bookmark
                                                  : Icons.bookmark_border,
                                              color: bookmarkedArticles
                                                      .contains(article)
                                                  ? Colors.red
                                                  : null,
                                            ),
                                            onPressed: () {
                                              toggleBookmark(article);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
