import 'package:flutter/material.dart';
import 'package:news_reading_application/CODE/Article.dart';
import 'package:news_reading_application/CODE/Search.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';  // Chuỗi tìm kiếm hiện tại
  List<Article> _searchResults = [];  // Kết quả tìm kiếm
  bool _isLoading = false;  // Biến kiểm tra trạng thái loading

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())  // Hiển thị khi đang tải
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index].title),
                  subtitle: Text(_searchResults[index].summary),
                  onTap: () {
                    // Navigate to article detail
                  },
                );
              },
            ),
    );
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
}
