import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/api_service/hooks/feed_api.dart';
import 'package:news_app/api_service/model/models.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/theme/app_color_extension.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const _accentTeal = Color(0xff2E9E8E);

  final List<String> _trendingTags = const [
    'Politics',
    'Economy',
    'Naija Tech',
    'Sports',
    'Entertainment',
    'Elections2027',
    'Fuel Price',
    'Health',
  ];

  List<FeedSource> _sources = [];
  bool _sourcesLoading = true;
  String? _sourcesError;

  @override
  void initState() {
    super.initState();
    _loadSources();
  }

  Future<void> _loadSources() async {
    setState(() {
      _sourcesLoading = true;
      _sourcesError = null;
    });
    try {
      final sources = await fetchFeedSources();
      if (!mounted) return;
      setState(() => _sources = sources);
    } catch (_) {
      if (!mounted) return;
      setState(() => _sourcesError = 'Could not load publishers');
    } finally {
      if (mounted) setState(() => _sourcesLoading = false);
    }
  }

  void _onTagTap(String tag) {
    context.push('${AppRoutes.search}?tag=$tag');
  }

  void _onSourceTap(FeedSource source) {
    context.push(AppRoutes.publisher, extra: {
      'sourceId': source.id,
      'displayName': source.source,
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),

            // Header
            Row(
              children: [
                Text(
                  'Discover',
                  style: TextStyle(
                    color: colors.textPri,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.search, color: colors.textPri),
                  onPressed: () => context.push(AppRoutes.search),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Popular Official Publishers — live from /feeds/sources
            Text(
              'Popular Official Publishers',
              style: TextStyle(
                color: colors.textPri,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            _buildPublishers(colors),
            const SizedBox(height: 28),

            // Trending Topics — quick-search hashtags
            Text(
              'Trending Topics',
              style: TextStyle(
                color: colors.textPri,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _trendingTags.map((tag) {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _onTagTap(tag),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colors.textSec.withOpacity(0.35),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '#$tag',
                      style: const TextStyle(
                        color: _accentTeal,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPublishers(colors) {
    if (_sourcesLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (_sourcesError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: InkWell(
            onTap: _loadSources,
            child: Text(
              '${_sourcesError!} · tap to retry',
              style: TextStyle(color: colors.textSec, fontSize: 12),
            ),
          ),
        ),
      );
    }
    if (_sources.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text('No publishers yet', style: TextStyle(color: colors.textSec, fontSize: 12)),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _sources.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 18,
        crossAxisSpacing: 8,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final source = _sources[index];
        return _PublisherTile(
          source: source,
          onTap: () => _onSourceTap(source),
        );
      },
    );
  }
}

class _PublisherTile extends StatelessWidget {
  final FeedSource source;
  final VoidCallback onTap;

  const _PublisherTile({required this.source, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final displayName = source.source.isNotEmpty ? source.source : '?';
    final color = Colors.primaries[displayName.hashCode % Colors.primaries.length];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Text(
              displayName[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colors.textPri,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${source.feedCount} Categorie${source.feedCount == 1 ? '' : 's'}',
            style: TextStyle(color: colors.textSec, fontSize: 10),
          ),
        ],
      ),
    );
  }
}