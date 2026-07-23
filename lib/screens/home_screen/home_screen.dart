import 'package:flutter/material.dart';
import 'package:news_app/api_service/hooks/articles_api.dart';
import 'package:news_app/api_service/model/models.dart' as api;
import 'package:news_app/componets/home/breaking_card.dart';
import 'package:news_app/componets/home/category_chip.dart';
import 'package:news_app/componets/home/home_header.dart';
import 'package:news_app/componets/home/news_card.dart';
import 'package:news_app/componets/home/section.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/theme/app_color_extension.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  bool _isLoading = true;
  String? _error;
  List<NewsArticle> _articles = [];

  static const _categories = ['All', 'Politics', 'Technology', 'Business'];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final category = _selectedCategory == 'All'
          ? null
          : _selectedCategory.toLowerCase();

      final result = await fetchArticles(category: category);
      debugPrint('[HomeScreen] fetched ${result.length} articles from API');
      if (result.isNotEmpty) {
        debugPrint('[HomeScreen] raw article[0].content length: ${result[0].content.length}');
        debugPrint('[HomeScreen] raw article[0].content preview: ${result[0].content.substring(0, result[0].content.length > 100 ? 100 : result[0].content.length)}');
      }

      final mapped = result.map(_mapArticle).toList();
      if (mapped.isNotEmpty) {
        debugPrint('[HomeScreen] mapped article[0].body length: ${mapped[0].body.length}');
      }

      setState(() {
        _articles = mapped;
        _isLoading = false;
      });
    } catch (e, st) {
      debugPrint('[HomeScreen] ERROR loading articles: $e');
      debugPrint('$st');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  NewsArticle _mapArticle(api.Article article) {
    final sourceName = article.feed?.name ?? 'Unknown';
    final cleanedBody = article.content.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    debugPrint('[HomeScreen._mapArticle] id=${article.id} content.length=${article.content.length} cleanedBody.length=${cleanedBody.length}');
    return NewsArticle(
      id: article.id,
      title: article.title,
      description: article.description.replaceAll(RegExp(r'<[^>]*>'), '').trim(),
      body: cleanedBody,
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
    final breaking = _articles.take(5).toList();
    final recent = _articles.skip(5).toList();

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Couldn't load news",
                                  style: TextStyle(color: colors.textPri)),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: _loadArticles,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadArticles,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 120),
                            child: Column(
                              children: [
                                if (breaking.isNotEmpty) ...[
                                  SectionTitle(title: "Trending", onSeeAll: () {}),
                                  const SizedBox(height: 18),
                                  BreakingNews(articles: breaking),
                                  const SizedBox(height: 30),
                                ],

                                SectionTitle(title: "Recent Stories", onSeeAll: () {}),
                                const SizedBox(height: 16),
                                CategoryFilter(
                                  categories: _categories,
                                  selected: _selectedCategory,
                                  onSelected: (category) {
                                    setState(() => _selectedCategory = category);
                                    _loadArticles();
                                  },
                                ),
                                const SizedBox(height: 8),

                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: recent.length,
                                  itemBuilder: (_, index) => NewsCard(article: recent[index]),
                                ),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}