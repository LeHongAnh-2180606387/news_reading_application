import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_reading_application/models/slider_model.dart';

class Sliders {
  List<sliderModel> sliders = [];

  Future<void> getSlider() async {
    String url =
        "https://newsapi.org/v2/everything?q=tesla&from=2024-12-10&sortBy=publishedAt&apiKey=bff42077feb94c4eaeafbc0891768e33";

    // Thực hiện gọi API
    var response = await http.get(Uri.parse(url));

    // Kiểm tra mã trạng thái HTTP
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      print(
          "API Response: $jsonData"); // In ra toàn bộ phản hồi API để kiểm tra

      // Kiểm tra nếu status của API là 'ok'
      if (jsonData['status'] == 'ok') {
        // Duyệt qua từng bài báo trong articles
        jsonData["articles"].forEach((element) {
          print("Article: $element"); // In ra từng bài báo để kiểm tra

          // Kiểm tra nếu có urlToImage và description
          if (element["urlToImage"] != null && element['description'] != null) {
            sliderModel slidermodel = sliderModel(
              title: element["title"],
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
              content: element["content"],
              author: element["author"],
            );
            sliders.add(slidermodel);
          }
        });

        if (sliders.isEmpty) {
          print("No valid sliders found.");
        } else {
          print("Sliders loaded: ${sliders.length}");
        }
      } else {
        print("API Response Error: ${jsonData['status']}");
      }
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  }
}
