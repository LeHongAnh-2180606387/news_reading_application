import 'package:dio/dio.dart';
import 'package:news_reading_application/config.dart';
import 'package:news_reading_application/models/article_dto.dart';
import 'package:news_reading_application/models/tag_dto.dart';
import 'package:news_reading_application/utils/utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio api = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<ApiService> initialize() async {
    api.interceptors.add(PrettyDioLogger(
      requestBody: true,
      responseBody: true,
    ));

    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      // For using short URL path in requests. We can use eg. /articles/ instead of https://url.com/articles/
      if (!options.path.contains('http')) {
        options.path = kApiUrl + options.path;
      }

      options.headers['Authorization'] = 'Basic $kBasicAuth';
      options.headers['x-language'] = 'en';

      return handler.next(options);
    }, onError: (DioException exception, handler) async {
      return handler.next(exception);
    }));

    return this;
  }

  // API endpoints

  /// Get all articles by article type. If tagId is provided, only articles with this tag will be returned.
  Future<List<ArticleDto>> getArticles() async {
    return api.get('/articles').then((response) {
      print('Response data for articles: ${response.data}');
      return (response.data['articles'] as List)
          .map((e) => ArticleDto.fromJSON(e))
          .toList(growable: false);
    }).catchError((onError) {
      print(
          'Error occurred while fetching articles: ${onError.response?.data}');
      Utils.showSnackBar(body: 'Articles cannot be loaded');
      return <ArticleDto>[];
    });
  }

  /// Search articles by article type and pattern.
  Future<List<ArticleDto>> searchArticles(
      String articleType, String pattern) async {
    return api.get('/articles/search/$articleType', queryParameters: {
      'page': 1,
      'count': 100,
      'pattern': pattern
    }).then((response) {
      return (response.data as List)
          .map((e) => ArticleDto.fromJSON(e))
          .toList(growable: false);
    }).catchError((onError) {
      Utils.showSnackBar(body: 'Articles cannot be loaded');
      return <ArticleDto>[];
    });
  }

  /// Get all tags.
  // Future<List<TagDto>> getTags() async {
  //   return api.get('/tags').then((response) {
  //     print(
  //         'Response data for tags: ${response.data}'); // Log dữ liệu trả về từ API
  //     return (response.data as List)
  //         .map((e) => TagDto.fromJSON(e))
  //         .toList(growable: false);
  //   }).catchError((onError) {
  //     print(
  //         'Error occurred while fetching tags: ${onError.response?.data}'); // Log lỗi chi tiết
  //     Utils.showSnackBar(body: 'Tags cannot be loaded');
  //     return <TagDto>[]; // Trả về danh sách rỗng nếu lỗi xảy ra
  //   });
  // }

  /// Send push notification token to server.
  void updateToken(String token) {
    api
        .post('/push-notifications/token',
            data: {'token': token, 'language': 'en'})
        .then((response) {})
        .catchError((onError) {});
  }
}
