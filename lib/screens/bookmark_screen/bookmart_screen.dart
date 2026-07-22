import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/api_service/hooks/bookmarks_api.dart';
import 'package:news_app/api_service/model/models.dart' as api;
import 'package:news_app/api_service/token_storage.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/theme/app_color_extension.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  bool _isLoading = true;
  String? _error;
  List<NewsArticle> _bookmarkedArticles = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final deviceId = await getDeviceId();
      final bookmarks = await fetchBookmarks(deviceId);

      final articles = bookmarks
          .where((b) => b.article != null)
          .map((b) => _mapArticle(b.article!))
          .toList();

      if (!mounted) return;
      setState(() {
        _bookmarkedArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  NewsArticle _mapArticle(api.Article article) {
    final sourceName = article.feed?.name ?? 'Unknown';
    return NewsArticle(
      id: article.id,
      title: article.title,
      description: _stripHtml(article.description),
      body: _stripHtml(article.content),
      image: article.imageUrl ?? 'https://picsum.photos/seed/${article.id}/400/400',
      source: sourceName,
      sourceInitial: sourceName.isNotEmpty ? sourceName[0].toUpperCase() : '?',
      sourceColor: Colors.primaries[article.id % Colors.primaries.length],
      timeAgo: _timeAgo(article.publishedAt),
      views: '',
      category: article.category ?? 'General', comments: '',
    );
  }

  String _stripHtml(String html) => html.replaceAll(RegExp(r'<[^>]*>'), '').trim();

  String _timeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
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

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Couldn't load bookmarks",
                                  style: TextStyle(color: colors.textPri)),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _loadBookmarks,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _bookmarkedArticles.isEmpty
                          ? Center(
                              child: Text(
                                'No bookmarks yet',
                                style: TextStyle(
                                  color: colors.textSec,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadBookmarks,
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                itemCount: _bookmarkedArticles.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 24),
                                itemBuilder: (context, index) {
                                  return _ArticleCard(article: _bookmarkedArticles[index]);
                                },
                              ),
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