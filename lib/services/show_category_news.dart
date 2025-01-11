// ignore_for_file: unused_import

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_reading_application/models/show_category.dart';
import 'package:news_reading_application/models/slider_model.dart';

class ShowCategoryNews {
  List<ShowCategoryModel> categories = [];

  Future<void> getCategoriesNews(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=tesla&from=2024-12-10&sortBy=publishedAt&apiKey=bff42077feb94c4eaeafbc0891768e33";
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ShowCategoryModel categoryModel = ShowCategoryModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
            author: element["author"],
          );
          categories.add(categoryModel);
        }
      });
    }
  }
}
