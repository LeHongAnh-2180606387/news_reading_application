import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hàm tìm kiếm bài viết theo tiêu đề
  Future<List<Map<String, dynamic>>> searchArticles(String query) async {
  try {
    print("Searching for: $query"); // Debugging
    QuerySnapshot querySnapshot = await _firestore
        .collection('articles')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    print("Query result count: ${querySnapshot.docs.length}"); // Debugging
    List<Map<String, dynamic>> articles = querySnapshot.docs
        .map((doc) => {          
              'description': doc['description'],
              'publishedAt': doc['publishedAt'],
              'title': doc['title'],
              'url': doc['url'],
              'urlToImage': doc['urlToImage'],
            })
        .toList();
    return articles;
  } catch (e) {
    print("Error searching articles: $e");
    return [];
  }
}

}
