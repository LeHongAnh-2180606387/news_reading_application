// ignore_for_file: unused_import

import 'tag_dto.dart'; // Import TagDto

class ArticleDto {
  final String? sourceId;
  final String sourceName;
  final String author;
  final String title;
  final String description;
  final String url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String content;

  ArticleDto({
    this.sourceId,
    required this.sourceName,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  // Factory method to convert from JSON response
  factory ArticleDto.fromJSON(Map<String, dynamic> json) {
    return ArticleDto(
      sourceId: json['source']?['id'],
      sourceName: json['source']?['name'] ?? '',
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : DateTime.now(),
      content: json['content'] ?? '',
    );
  }
}
