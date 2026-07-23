import 'package:flutter/material.dart';
import 'package:news_app/api_service/hooks/articles_api.dart';
import 'package:news_app/componets/home/category_chip.dart';
import 'package:news_app/componets/home/news_card.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/theme/app_color_extension.dart';
import 'package:news_app/utils/article_mapper.dart';


class SeeAllScreen extends StatefulWidget {
  final String title;
  final String? initialCategory;

  const SeeAllScreen({
    super.key,
    this.title = 'All News',
    this.initialCategory,
  });

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  static const _categories = [
    'All',
    'Politics',
    'Technology',
    'Business',
    'Sport',
    'Entertainment',

  ];


  static const _categorySlugs = {
    'Politics': 'politics',
    'Technology': 'technology',
    'Business': 'business',
    'Sport': 'sports',
    'Entertainment': 'entertainment',

  };

  static const _pageSize = 20;

  late String _selectedCategory;
  final ScrollController _scrollController = ScrollController();

  final List<NewsArticle> _articles = [];
  int _page = 1;
  bool _isLoadingFirstPage = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'All';
    _scrollController.addListener(_onScroll);
    _loadFirstPage();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  String? _apiCategory(String label) =>
      label == 'All' ? null : _categorySlugs[label];

  void _onScroll() {
    if (!_hasMore || _isLoadingMore || _isLoadingFirstPage) return;
    final threshold = _scrollController.position.maxScrollExtent - 300;
    if (_scrollController.position.pixels >= threshold) {
      _loadNextPage();
    }
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _isLoadingFirstPage = true;
      _error = null;
      _page = 1;
      _hasMore = true;
    });

    try {
      final category = _apiCategory(_selectedCategory);

      // PAGINATION PARAM
      final result = await fetchArticles(
        category: category,
        page: _page,
        limit: _pageSize,
      );

      final mapped = result.map(mapApiArticleToNewsArticle).toList();

      if (!mounted) return;
      setState(() {
        _articles
          ..clear()
          ..addAll(mapped);
        _hasMore = result.length == _pageSize;
        _isLoadingFirstPage = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoadingFirstPage = false;
      });
    }
  }

  Future<void> _loadNextPage() async {
    setState(() => _isLoadingMore = true);

    try {
      final category = _apiCategory(_selectedCategory);
      final nextPage = _page + 1;

      // PAGINATION PARAM
      final result = await fetchArticles(
        category: category,
        page: nextPage,
        limit: _pageSize,
      );

      final mapped = result.map(mapApiArticleToNewsArticle).toList();

      if (!mounted) return;
      setState(() {
        _page = nextPage;
        _articles.addAll(mapped);
        _hasMore = result.length == _pageSize;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingMore = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load more: $e')),
      );
    }
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
    _loadFirstPage();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(color: colors.textPri, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: colors.textPri),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            CategoryFilter(
              categories: _categories,
              selected: _selectedCategory,
              onSelected: _onCategorySelected,
            ),
            const SizedBox(height: 8),
            Expanded(child: _buildBody(colors)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(dynamic colors) {
    if (_isLoadingFirstPage) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Couldn't load news", style: TextStyle(color: colors.textPri)),
            const SizedBox(height: 8),
            TextButton(onPressed: _loadFirstPage, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_articles.isEmpty) {
      return Center(
        child: Text('No articles found', style: TextStyle(color: colors.textPri)),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFirstPage,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 120),
        itemCount: _articles.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _articles.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return NewsCard(article: _articles[index]);
        },
      ),
    );
  }
}