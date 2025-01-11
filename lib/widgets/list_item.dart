import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_reading_application/models/article_dto.dart';
import 'package:news_reading_application/theme/ui_helpers.dart';

class ArticleListItem extends StatelessWidget {
  final ArticleDto article;
  final Function(ArticleDto) onTap;

  const ArticleListItem({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onTap(article),
          child: SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        UIHelper.verticalSpace(2),
                        Text(
                          article.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            DateFormat('dd.MM.yyyy')
                                .format(article.publishedAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: 70.0,
                    width: 100.0,
                    color: Colors.black12,
                    child: article.urlToImage != null
                        ? FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(article.urlToImage!),
                          )
                        : const Icon(Icons.image_not_supported,
                            color: Colors.black54, size: 50.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}
