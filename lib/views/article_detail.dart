// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_reading_application/models/article_dto.dart';
import 'package:news_reading_application/theme/style.dart';
import 'package:news_reading_application/theme/ui_helpers.dart';
import 'package:news_reading_application/widgets/tag.dart';

class ArticleDetail extends StatelessWidget {
  final ArticleDto article;

  const ArticleDetail({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),
            Text(
              'By ${article.author ?? 'Unknown'} | Published on ${article.publishedAt != null ? DateFormat('dd.MM.yyyy').format(article.publishedAt!) : 'Unknown'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Image.network(article.urlToImage ?? ''),
            const SizedBox(height: 16.0),
            Text(
              article.content ?? 'Content not available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
