import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_app/api_service/hooks/search_api.dart';
import 'package:news_app/api_service/model/models.dart' as api;
import 'package:news_app/componets/home/news_card.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/theme/app_color_extension.dart';




class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  final String? initialTag;

  const SearchScreen({super.key, this.initialQuery, this.initialTag});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  List<NewsArticle> _results = [];
  List<String> _tags = [];
  String? _selectedTag;

  bool _loading = false;
  bool _loadingMore = false;
  bool _hasSearched = false;
  bool _hasMore = true;
  String? _error;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialQuery ?? '';
    _selectedTag = widget.initialTag;
    _loadTags();

    if ((widget.initialQuery?.isNotEmpty ?? false) || widget.initialTag != null) {
      _runSearch();
    } else {
      _focusNode.requestFocus();
    }
  }

  Future<void> _loadTags() async {
    try {
      final tags = await fetchSearchTags();
      if (mounted) setState(() => _tags = tags);
    } catch (_) {
      // tags are a nice-to-have, fail silently
    }
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), _runSearch);
    setState(() {}); // refresh clear button
  }

  Future<void> _runSearch({bool loadMore = false}) async {
    final q = _controller.text.trim();
    final tag = _selectedTag;

    if (q.isEmpty && tag == null) {
      setState(() {
        _results = [];
        _hasSearched = false;
        _error = null;
      });
      return;
    }

    if (loadMore) {
      if (_loadingMore || !_hasMore) return;
      setState(() => _loadingMore = true);
    } else {
      setState(() {
        _loading = true;
        _hasSearched = true;
        _hasMore = true;
        _error = null;
      });
    }

    try {
      final params = SearchParams(
        q: q.isEmpty ? null : q,
        tag: tag,
        page: loadMore ? _page + 1 : 1,
      );
      final res = await searchArticles(params);
      final mappedArticles = res.articles.map(_mapArticle).toList();

      setState(() {
        _page = params.page;
        _results = loadMore ? [..._results, ...mappedArticles] : mappedArticles;
        _hasMore = res.articles.length == params.limit;
      });
    } catch (_) {
      setState(() => _error = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() { _loading = false; _loadingMore = false; });
    }
  }

  NewsArticle _mapArticle(api.Article article) {
    final sourceName = article.feed?.name ?? 'Unknown';
    return NewsArticle(
      id: article.id,
      title: article.title,
      description: article.description.replaceAll(RegExp(r'<[^>]*>'), '').trim(),
      image: article.imageUrl ?? 'https://picsum.photos/seed/${article.id}/400/400',
      source: sourceName,
      sourceInitial: sourceName.isNotEmpty ? sourceName[0].toUpperCase() : '?',
      sourceColor: Colors.primaries[article.id % Colors.primaries.length],
      timeAgo: _timeAgo(article.publishedAt),
      views: '',
      category: article.category ?? 'General',
      body: '',
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

  void _selectTag(String tag) {
    setState(() => _selectedTag = _selectedTag == tag ? null : tag);
    _runSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(colors),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 14),
              _buildTagRow(colors),
            ],
            const SizedBox(height: 8),
            Expanded(child: _buildBody(colors)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.textPri, size: 20),
          ),
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(50),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: widget.initialQuery == null,
                style: TextStyle(color: colors.textPri),
                onChanged: _onQueryChanged,
                onSubmitted: (_) => _runSearch(),
                decoration: InputDecoration(
                  hintText: "Search news...",
                  hintStyle: TextStyle(color: colors.textSec),
                  prefixIcon: Icon(Icons.search, color: colors.textSec),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close, color: colors.textSec, size: 18),
                          onPressed: () {
                            _controller.clear();
                            setState(() { _results = []; _hasSearched = false; });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagRow(colors) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _tags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final tag = _tags[i];
          final selected = _selectedTag == tag;
          return GestureDetector(
            onTap: () => _selectTag(tag),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? Colors.red : colors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '#$tag',
                style: TextStyle(
                  color: selected ? Colors.white : colors.textSec,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(colors) {
    if (_loading && _results.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) return _buildMessage(colors, _error!, Icons.error_outline);
    if (!_hasSearched) return _buildMessage(colors, "Search articles or tap a tag", Icons.search);
    if (_results.isEmpty) return _buildMessage(colors, "No results found", Icons.search_off);

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200) {
          _runSearch(loadMore: true);
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        itemCount: _results.length + (_loadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i >= _results.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return NewsCard(article: _results[i]);
        },
      ),
    );
  }

  Widget _buildMessage(colors, String text, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: colors.textSec),
          const SizedBox(height: 12),
          Text(text, style: TextStyle(color: colors.textSec)),
        ],
      ),
    );
  }
}