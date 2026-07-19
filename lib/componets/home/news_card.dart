import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/theme/app_color_extension.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: InkWell(
        onTap: () => context.push(AppRoutes.article, extra: article),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.textPri,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 9,
                        backgroundColor: article.sourceColor,
                        child: Text(
                          article.sourceInitial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        article.source,
                        style: TextStyle(
                          color: colors.textPri,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Text(
                        article.timeAgo,
                        style: TextStyle(color: colors.textSec, fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.visibility_outlined, size: 13, color: colors.textSec),
                      const SizedBox(width: 3),
                      Text(
                        article.views,
                        style: TextStyle(color: colors.textSec, fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Image + actions
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    article.image,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}