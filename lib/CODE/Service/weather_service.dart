import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

// Hàm lấy vị trí của người dùng
Future<Position> getUserLocation() async {  // Đổi tên thành public
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error('Location permissions are denied.');
    }
  }

  return await Geolocator.getCurrentPosition();
}

// Hàm lấy mã icon thời tiết từ OpenWeatherMap API
// Hàm lấy mô tả thời tiết từ OpenWeatherMap API
Future<String> fetchWeatherDescription(double lat, double lon) async {
  final apiKey = 'b50ff73c8fa7e811a24ce4b1ae6c704b';  // Thay bằng API key của bạn
  final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    String description = data['weather'][0]['description']; // Lấy mô tả thời tiết từ API
    return description;
  } else {
    throw Exception('Failed to load weather data');
  }
}


Future<String> fetchWeatherIcon(double lat, double lon) async {
  final apiKey = 'b50ff73c8fa7e811a24ce4b1ae6c704b';  // API key của bạn từ OpenWeatherMap
  final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'; // Thêm units=metric để lấy nhiệt độ ở độ C

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print('API Response: $data'); // In ra toàn bộ response từ API để kiểm tra
    String iconCode = data['weather'][0]['icon']; // Lấy mã icon từ API
    print('Icon Code: $iconCode');  // In ra mã icon để kiểm tra
    return iconCode;
  } else {
    throw Exception('Failed to load weather data');
  }
}


String getWeatherAnimation(String iconCode) {
  switch (iconCode) {
    case '01d':  // Clear sky (day)
      return 'assets/Cloud.json';
    case '01n':  // Clear sky (night)
      return 'assets/Night.json';
    case '02d':  // Few clouds (day)
      return 'assets/Cloud.json';
    case '02n':  // Few clouds (night)
      return 'assets/Night.json';
    case '03d':  // Scattered clouds (day)
      return 'assets/Sun.json';
    case '03n':  // Scattered clouds (night)
      return 'assets/Sun.json';
    case '04d':  // Broken clouds (day)
      return 'assets/Cloudy.json'; // Ví dụ cho mây rải rác
    case '04n':  // Broken clouds (night)
      return 'assets/CloudyNight.json'; // Ví dụ cho mây rải rác vào ban đêm
    case '09d':  // Shower rain (day)
      return 'assets/Rainy.json';
    case '09n':  // Shower rain (night)
      return 'assets/RainyNight.json';
    case '10d':  // Rain (day)
      return 'assets/Rainy.json';
    case '10n':  // Rain (night)
      return 'assets/RainyNight.json';
    case '11d':  // Thunderstorm (day)
      return 'assets/Thunderstorm.json';
    case '11n':  // Thunderstorm (night)
      return 'assets/ThunderstormNight.json';
    case '13d':  // Snow (day)
      return 'assets/Snow.json';
    case '13n':  // Snow (night)
      return 'assets/SnowNight.json';
    case '50d':  // Mist (day)
      return 'assets/Mist.json';
    case '50n':  // Mist (night)
      return 'assets/MistNight.json';
    default:
      return 'assets/DefaultWeather.json';  // Default animation if no match
  }
}
