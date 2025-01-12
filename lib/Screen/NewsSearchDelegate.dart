import 'package:flutter/material.dart';
import 'package:news_reading_application/CODE/Service/SearchService.dart';
import 'package:news_reading_application/Screen/news_webview.dart';
import 'package:firebase_storage/firebase_storage.dart';  // Import Firebase Storage

class NewsSearchDelegate extends SearchDelegate {
  final SearchService searchService;

  NewsSearchDelegate({required this.searchService});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Xóa query khi nhấn clear
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Đóng search khi nhấn back
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
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

        // Loại bỏ các kết quả trùng lặp dựa trên URL
        final results = <String, Map<String, dynamic>>{};
        snapshot.data!.forEach((article) {
          final url = article['url'];
          if (url != null) {
            results[url] = article; // Chỉ thêm vào nếu URL không null
          }
        });

        // Chuyển lại thành list từ set đã lọc
        final uniqueResults = results.values.toList();

        return ListView.builder(
          itemCount: uniqueResults.length,
          itemBuilder: (context, index) {
            final article = uniqueResults[index];
            final imageUrl = article['urlToImage'];

            return ListTile(
              leading: imageUrl.isNotEmpty
                  ? Image.network(imageUrl) // Hiển thị hình ảnh nếu có
                  : null,
              title: Text(
                article['title'] ?? 'No Title',
                maxLines: 1, // Giới hạn title ở 1 dòng
                overflow: TextOverflow.ellipsis, // Thêm dấu "..." nếu nội dung vượt quá
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                article['description'] ?? 'No Description',
                maxLines: 2, // Giới hạn description ở 2 dòng
                overflow: TextOverflow.ellipsis, // Thêm dấu "..." nếu nội dung vượt quá
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
    return Container(); // Bạn có thể hiển thị gợi ý ở đây nếu cần
  }
}
