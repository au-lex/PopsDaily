import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/data/mock_news.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/theme/app_color_extension.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  static const _accentTeal = Color(0xff2E9E8E);

  int _selectedFilter = 0;
  final _filters = const ['Reading List', 'References', 'Research'];

  List<NewsArticle> get _bookmarkedArticles => [
        ...mockBreakingNews,
        ...mockRecentStories,
      ].where((a) => a.isBookmarked).toList();

  @override
  Widget build(BuildContext context) {
    final articles = _bookmarkedArticles;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  Text(
                    'Bookmark',
                    style: TextStyle(
                      color: colors.textPri,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.search, color: colors.textPri),
                    onPressed: () {},
                  ),
                ],
              ),
            ),



            const SizedBox(height: 27),

            // Article list
            Expanded(
              child: articles.isEmpty
                  ? Center(
                      child: Text(
                        'No bookmarks yet',
                        style: TextStyle(
                          color: colors.textSec,
                          fontSize: 15,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: articles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        return _ArticleCard(article: articles[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final NewsArticle article;

  const _ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: () => context.push(AppRoutes.article, extra: article),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    fontSize: 15,
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
                    const SizedBox(width: 12),
                    Icon(Icons.visibility_outlined, size: 14, color: colors.textSec),
                    const SizedBox(width: 4),
                    Text(
                      article.views,
                      style: TextStyle(color: colors.textSec, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  article.image,
                  width: 92,
                  height: 92,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}