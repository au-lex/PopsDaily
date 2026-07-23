import 'package:flutter/material.dart';
import 'package:news_app/api_service/hooks/articles_api.dart';
import 'package:news_app/api_service/model/models.dart' as api;
import 'package:news_app/componets/home/news_card.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/theme/app_color_extension.dart';

class PublisherArticlesScreen extends StatefulWidget {
  final int sourceId;
  final String? displayName;

  const PublisherArticlesScreen({
    super.key,
    required this.sourceId,
    this.displayName,
  });

  @override
  State<PublisherArticlesScreen> createState() => _PublisherArticlesScreenState();
}

class _PublisherArticlesScreenState extends State<PublisherArticlesScreen> {
  List<NewsArticle> _articles = [];
  bool _loading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _error;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles({bool loadMore = false}) async {
    if (loadMore) {
      if (_loadingMore || !_hasMore) return;
      setState(() => _loadingMore = true);
    } else {
      setState(() {
        _loading = true;
        _error = null;
        _hasMore = true;
      });
    }

    try {
      final nextPage = loadMore ? _page + 1 : 1;
      final res = await fetchArticlesBySourceId(widget.sourceId, page: nextPage);
      final mapped = res.articles.map(_mapArticle).toList();

      setState(() {
        _page = res.page;
        _articles = loadMore ? [..._articles, ...mapped] : mapped;
        _hasMore = res.hasMore;
      });
    } catch (e) {
      setState(() => _error = "Couldn't load articles");
    } finally {
      if (mounted) setState(() { _loading = false; _loadingMore = false; });
    }
  }

  NewsArticle _mapArticle(api.Article article) {
    final sourceName = article.feed?.name ?? widget.displayName ?? 'Unknown';
    return NewsArticle(
      id: article.id,
      title: article.title,
      description: article.description.replaceAll(RegExp(r'<[^>]*>'), '').trim(),
      body: article.content.replaceAll(RegExp(r'<[^>]*>'), '').trim(),
      image: article.imageUrl ?? 'https://picsum.photos/seed/${article.id}/400/400',
      source: sourceName,
      sourceInitial: sourceName.isNotEmpty ? sourceName[0].toUpperCase() : '?',
      sourceColor: Colors.primaries[article.id % Colors.primaries.length],
      timeAgo: _timeAgo(article.publishedAt),
      views: '',
      category: article.category ?? 'General',
      comments: '',
    );
  }

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
    final title = widget.displayName ?? 'Publisher';

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.textPri, size: 20),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: colors.textPri,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody(colors)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(colors) {
    if (_loading && _articles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: TextStyle(color: colors.textPri)),
            const SizedBox(height: 8),
            TextButton(onPressed: () => _loadArticles(), child: const Text('Retry')),
          ],
        ),
      );
    }
    if (_articles.isEmpty) {
      return Center(
        child: Text('No articles from this publisher yet', style: TextStyle(color: colors.textSec)),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadArticles(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
            _loadArticles(loadMore: true);
          }
          return false;
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          itemCount: _articles.length + (_loadingMore ? 1 : 0),
          itemBuilder: (_, i) {
            if (i >= _articles.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return NewsCard(article: _articles[i]);
          },
        ),
      ),
    );
  }
}