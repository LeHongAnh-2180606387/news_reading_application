import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm lấy gợi ý từ Firestore với hình ảnh
  Future<List<Map<String, dynamic>>> getSuggestions(String query) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('articles').get();

      // Lọc các tiêu đề có chứa từ khóa và lấy thêm hình ảnh
      List<Map<String, dynamic>> suggestions = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((article) => article['title']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .map((article) => {
                'title': article['title'].toString(),
                'urlToImage': article['urlToImage'] ?? '', // Lấy hình ảnh hoặc rỗng nếu không có
              })
          .toList();

      return suggestions;
    } catch (e) {
      print("Error getting suggestions: $e");
      return [];
    }
  }


  // Hàm tìm kiếm bài viết theo tiêu đề
 Future<List<Map<String, dynamic>>> searchArticles(String query) async {
  try {
    // Lấy tất cả các bài báo từ Firestore
    QuerySnapshot querySnapshot = await _firestore.collection('articles').get();

    // Lọc các bài báo có từ khóa xuất hiện trong title
    List<Map<String, dynamic>> articles = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((article) => article['title']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .map((article) => {
              'description': article['description'],
              'publishedAt': article['publishedAt'],
              'title': article['title'],
              'url': article['url'],
              'urlToImage': article['urlToImage'],
            })
        .toList();

    return articles;
  } catch (e) {
    print("Error searching articles: $e");
    return [];
  }
}


}
