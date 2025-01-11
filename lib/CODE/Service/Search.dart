import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_reading_application/CODE/Model/Article.dart';

Future<List<Article>> searchArticles(String query) async {
  // Tìm kiếm theo tiêu đề
  final titleResult = await FirebaseFirestore.instance
      .collection('articles')
      .where('title', isGreaterThanOrEqualTo: query)
      .where('title', isLessThanOrEqualTo: query + '\uf8ff')
      .limit(10)
      .get();

  // Tìm kiếm theo từ khóa
  final keywordsResult = await FirebaseFirestore.instance
      .collection('articles')
      .where('keywords', arrayContains: query)
      .get();

  // Hợp nhất kết quả từ cả hai truy vấn
  final combinedResults = {
    ...titleResult.docs.map((doc) => Article.fromFirestore(doc)),
    ...keywordsResult.docs.map((doc) => Article.fromFirestore(doc))
  };

  // Chuyển đổi set thành list để trả về
  return combinedResults.toList();
}
