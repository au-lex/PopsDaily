import 'package:flutter/material.dart';
import 'package:news_app/api_service/hooks/articles_api.dart';
import 'package:news_app/componets/home/breaking_card.dart';
import 'package:news_app/componets/home/category_chip.dart';
import 'package:news_app/componets/home/home_header.dart';
import 'package:news_app/componets/home/news_card.dart';
import 'package:news_app/componets/home/section.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/screens/news_details/full_news.dart';
import 'package:news_app/screens/news_details/trending_news.dart';


import 'package:news_app/theme/app_color_extension.dart';
import 'package:news_app/utils/article_mapper.dart';

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
      final result = await fetchArticles(category: category, limit: 20);
      final mapped = result.map(mapApiArticleToNewsArticle).toList();

      setState(() {
        _articles = mapped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _openSeeAll() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SeeAllScreen(
          title: 'Recent Stories',
          initialCategory: _selectedCategory,
        ),
      ),
    );
  }

  void _openTrending() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TrendingScreen()),
    );
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
                          Text(
                            "Couldn't load news",
                            style: TextStyle(color: colors.textPri),
                          ),
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
                              SectionTitle(
                                title: "Trending",
                                onSeeAll: _openTrending,
                              ),
                              const SizedBox(height: 18),
                              BreakingNews(articles: breaking),
                              const SizedBox(height: 30),
                            ],

                            SectionTitle(
                              title: "Recent Stories",
                              onSeeAll: _openSeeAll,
                            ),
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
                              itemBuilder: (_, index) =>
                                  NewsCard(article: recent[index]),
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