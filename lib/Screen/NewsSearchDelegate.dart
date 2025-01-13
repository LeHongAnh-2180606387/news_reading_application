import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:news_reading_application/CODE/Service/SearchService.dart';
import 'package:news_reading_application/Screen/news_webview.dart';

class NewsSearchDelegate extends SearchDelegate {
  final SearchService searchService;

  NewsSearchDelegate({required this.searchService});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue, // Nền xanh
        iconTheme: IconThemeData(color: Colors.white), // Màu biểu tượng
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white, // Nền trắng của ô tìm kiếm
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Bo góc
          borderSide: BorderSide.none, // Không viền
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Xóa nội dung tìm kiếm
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Đóng tìm kiếm
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Please enter a search term.'));
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: searchService.searchArticles(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error occurred during search.'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found.'));
        }

        final Set<String> seen = HashSet();
        final List<Map<String, dynamic>> uniqueResults = snapshot.data!
            .where((article) =>
                article['url'] != null && seen.add(article['url'] as String))
            .toList();

        return ListView.builder(
          itemCount: uniqueResults.length,
          itemBuilder: (context, index) {
            final article = uniqueResults[index];
            final imageUrl = article['urlToImage'] ?? '';

            return ListTile(
              leading: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : null,
              title: Text(
                article['title'] ?? 'No Title',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                article['description'] ?? 'No Description',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                      url: article['url'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Type to start searching...'));
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: searchService.getSuggestions(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching suggestions.'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No suggestions found.'));
        }

        final Set<String> seenTitles = HashSet();
        final List<Map<String, dynamic>> uniqueSuggestions = snapshot.data!
            .where((article) => seenTitles.add(article['title'] as String))
            .toList();

        return ListView.builder(
          itemCount: uniqueSuggestions.length,
          itemBuilder: (context, index) {
            final suggestion = uniqueSuggestions[index];
            final truncatedSuggestion = suggestion['title'].length > 50
                ? '${suggestion['title'].substring(0, 50)}...'
                : suggestion['title'];
            final imageUrl = suggestion['urlToImage'];

            return ListTile(
              leading: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.image_not_supported, size: 50),
              title: Text(truncatedSuggestion),
              onTap: () {
                query = suggestion['title']; // Đặt query từ gợi ý đã chọn
                showResults(context); // Hiển thị kết quả tìm kiếm
              },
            );
          },
        );
      },
    );
  }
}
