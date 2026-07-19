import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/model/news_model.dart';

class BreakingNews extends StatelessWidget {
  final List<NewsArticle> articles;

  const BreakingNews({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: articles.length,
        itemBuilder: (_, index) {
          final article = articles[index];
          return GestureDetector(
            onTap: () => context.push(AppRoutes.article, extra: article),
            child: Container(
              width: 320,
              margin: const EdgeInsets.only(right: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      article.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(.15),
                          Colors.black.withOpacity(.25),
                          Colors.black.withOpacity(.75),
                          Colors.black.withOpacity(.95),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "BREAKING",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Text(
                          article.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          article.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: article.sourceColor,
                              child: Text(
                                article.sourceInitial,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              article.source,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.access_time_rounded,
                              size: 15,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              article.timeAgo,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}