import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../utils/app_colors.dart';
import '../utils/date_formatter.dart';
import 'news_image.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;

  const ArticleCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const meta = TextStyle(fontSize: 12, color: AppColors.textSecondary);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null) NewsImage(url: article.urlToImage!),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (article.description != null)
                    Text(
                      article.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textSecondary),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (article.author != null) ...[
                        const Icon(Icons.newspaper,
                            size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(article.author!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: meta),
                        ),
                        const SizedBox(width: 16),
                      ],
                      const Icon(Icons.access_time,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(DateFormatter.formatDate(article.publishedAt),
                          style: meta),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
