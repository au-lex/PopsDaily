import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/config/routes.dart';
import 'package:news_app/data/mock_news.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/theme/app_color_extension.dart';

class ArticleScreen extends StatefulWidget {
  final NewsArticle article;

  const ArticleScreen({super.key, required this.article});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool _isBookmarked = false;

  bool _isReading = false;

  bool _isSummaryVisible = false;
  bool _isGeneratingSummary = false;

  Future<void> _onToggleListen() async {
    // TODO: wire to your actual text-to-speech package (e.g. flutter_tts).
    // This just flips a play/pause state for now.
    setState(() => _isReading = !_isReading);
  }

  Future<void> _onToggleSummary() async {
    if (_isSummaryVisible) {
      setState(() => _isSummaryVisible = false);
      return;
    }

    setState(() => _isGeneratingSummary = true);
    // TODO: wire to your actual summarization API call.
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isGeneratingSummary = false;
      _isSummaryVisible = true;
    });
  }

  /// Builds a "Recommended for You" list from the app's mock data,
  /// excluding the currently open article. Same-category articles are
  /// surfaced first, then the rest fill in up to [limit].
  List<NewsArticle> _buildRecommendations(
    NewsArticle current, {
    int limit = 6,
  }) {
    final all = [...mockBreakingNews, ...mockRecentStories];

    final sameCategory = <NewsArticle>[];
    final others = <NewsArticle>[];

    for (final a in all) {
      if (a.title == current.title) continue;
      if (a.category == current.category) {
        sameCategory.add(a);
      } else {
        others.add(a);
      }
    }

    return [...sameCategory, ...others].take(limit).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final article = widget.article;
    final recommended = _buildRecommendations(article);

    return Scaffold(
      backgroundColor: colors.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: colors.bg,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios, color: colors.textPri),
            ),
            actions: [
              IconButton(
                onPressed: () => setState(() => _isBookmarked = !_isBookmarked),
                icon: Icon(
                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: _isBookmarked ? colors.pri : colors.textPri,
                ),
              ),
              const SizedBox(width: 6),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(article.image, fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.pri,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      article.category,
                      style: TextStyle(
                        color: colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: colors.textSec),
                      const SizedBox(width: 5),
                      Text(
                        article.timeAgo,
                        style: TextStyle(color: colors.textSec),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Text(
                    article.title,
                    style: TextStyle(
                      color: colors.textPri,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: article.sourceColor,
                        child: Text(
                          article.sourceInitial,
                          style: TextStyle(
                            color: colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.source,
                            style: TextStyle(
                              color: colors.textPri,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${article.views} views • ${article.comments} comments',
                            style: TextStyle(color: colors.textSec),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: _ActionPillButton(
                          colors: colors,
                          icon: _isReading
                              ? Icons.pause
                              : Icons.volume_up_outlined,
                          label: _isReading ? 'Pause' : 'Listen',
                          isActive: _isReading,
                          onTap: _onToggleListen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionPillButton(
                          colors: colors,
                          icon: Icons.auto_awesome,
                          label: _isSummaryVisible
                              ? 'Hide Summary'
                              : 'AI Summary',
                          isActive: _isSummaryVisible,
                          isLoading: _isGeneratingSummary,
                          onTap: _onToggleSummary,
                        ),
                      ),
                    ],
                  ),

                  if (_isReading) ...[
                    const SizedBox(height: 12),
                    _ReadingIndicator(colors: colors),
                  ],

                  const SizedBox(height: 35),

                  Text(
                    article.body,
                    style: TextStyle(
                      color: colors.textSec,
                      fontSize: 17,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 35),

                  // AI Summary block — only shown once generated via the
                  // button above. Content is still placeholder; wire to a
                  // real summarization call if/when you have one.
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 250),
                    crossFadeState: _isSummaryVisible
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.auto_awesome, color: colors.pri),
                              const SizedBox(width: 8),
                              Text(
                                "AI Summary",
                                style: TextStyle(
                                  color: colors.textPri,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "• Key developments summarized here.",
                            style: TextStyle(color: colors.textSec),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "• Second key point from the article.",
                            style: TextStyle(color: colors.textSec),
                          ),
                        ],
                      ),
                    ),
                    secondChild: const SizedBox(width: double.infinity),
                  ),
                  const SizedBox(height: 40),

                  if (recommended.isNotEmpty) ...[
                    Text(
                      'Recommended for You',
                      style: TextStyle(
                        color: colors.textPri,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),

          if (recommended.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: recommended.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    return _RecommendedNewsCard(article: recommended[index]);
                  },
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 4)),
        ],
      ),
    );
  }
}

/// Recommended-for-you card, styled to match [NewsCard]'s typography,
/// source-avatar treatment, and timeAgo/views row — just arranged
/// vertically (image on top) so it fits a horizontal carousel.
class _RecommendedNewsCard extends StatelessWidget {
  const _RecommendedNewsCard({required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 210,
      child: InkWell(
        onTap: () => context.push(AppRoutes.article, extra: article),
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                article.image,
                width: double.infinity,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 110,
                  color: colors.surface,
                  child: Icon(Icons.image_not_supported, color: colors.textSec),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.textPri,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

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
                Expanded(
                  child: Text(
                    article.source,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.textPri,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
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
                Icon(
                  Icons.visibility_outlined,
                  size: 13,
                  color: colors.textSec,
                ),
                const SizedBox(width: 3),
                Text(
                  article.views,
                  style: TextStyle(color: colors.textSec, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionPillButton extends StatelessWidget {
  const _ActionPillButton({
    required this.colors,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.isLoading = false,
  });

  final AppColorsExtension colors;
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: isActive ? colors.pri.withOpacity(0.15) : colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? colors.pri : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.pri,
                ),
              )
            else
              Icon(
                icon,
                size: 18,
                color: isActive ? colors.pri : colors.textPri,
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                isLoading ? 'Summarizing…' : label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isActive ? colors.pri : colors.textPri,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingIndicator extends StatelessWidget {
  const _ReadingIndicator({required this.colors});

  final AppColorsExtension colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.pri.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.graphic_eq, size: 18, color: colors.pri),
          const SizedBox(width: 8),
          Text(
            'Reading article aloud…',
            style: TextStyle(
              color: colors.pri,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
