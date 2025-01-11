import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';


class ArticleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm phương thức tải lên hình ảnh lên Imgur
  Future<String?> uploadImageToImgur(File imageFile) async {
    try {
      final String clientId = '53ba74a3e203c37b6cb824e21961634e-34d256e5-a5fa-4386-9fd5-76f10ac0360e'; // Thay bằng Client ID của bạn

      // Tạo yêu cầu HTTP
      var request = http.MultipartRequest('POST', Uri.parse('https://api.imgur.com/3/upload'));
      request.headers['Authorization'] = 'Client-ID $clientId';

      // Thêm file hình ảnh vào yêu cầu
      var pic = await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(pic);

      // Gửi yêu cầu
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      // Kiểm tra phản hồi
      if (response.statusCode == 200) {
        var jsonData = json.decode(responseData.body);
        return jsonData['data']['link'];  // Trả về URL của ảnh đã tải lên
      } else {
        print('Error uploading image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Phương thức lưu bài viết
  Future<void> saveArticle(String title, String summary, String content, File? image) async {
    try {
      String? imageUrl;
      if (image != null) {
        // Tải lên hình ảnh lên Imgur và nhận URL
        imageUrl = await uploadImageToImgur(image);
      }

      // Lưu bài viết vào Firestore
      await _firestore.collection('articles').add({
        'title': title,
        'summary': summary,
        'content': content,
        'imageUrl': imageUrl, // Lưu URL hình ảnh
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Article saved successfully');
    } catch (e) {
      print('Error saving article: $e');
      throw e;
    }
  }

// Lấy danh sách bài báo từ Firestore
  Future<List<Map<String, dynamic>>> fetchArticles() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('articles').get();
      List<Map<String, dynamic>> articles = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      return articles;
    } catch (e) {
      print('Error fetching articles: $e');
      return [];
    }
  }

}

