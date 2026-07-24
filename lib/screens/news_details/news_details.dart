import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news_app/api_service/hooks/articles_api.dart';
import 'package:news_app/api_service/hooks/bookmarks_api.dart';
import 'package:news_app/api_service/token_storage.dart';

import 'package:news_app/model/news_model.dart';
import 'package:news_app/theme/app_color_extension.dart';

class ArticleScreen extends StatefulWidget {
  final NewsArticle article;

  const ArticleScreen({super.key, required this.article});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen>
    with SingleTickerProviderStateMixin {
  bool _isBookmarked = false;
  bool _isBookmarkLoading = false;
  bool _isReading = false;
  bool _isGeneratingSummary = false;

  late String _displayBody;
  bool _isExtracting = false;
  String? _extractError;

  List<String> _summaryBullets = [];

  late final AnimationController _readingProgressController;

  bool get _hasNoContent =>
      widget.article.body.isEmpty || widget.article.body == widget.article.description;

  @override
  void initState() {
    super.initState();
    _displayBody = widget.article.body;
    if (_hasNoContent) {
      _extractContent();
    }
    _checkBookmarkStatus();

    _readingProgressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
  }

  @override
  void dispose() {
    _readingProgressController.dispose();
    super.dispose();
  }

  Future<void> _checkBookmarkStatus() async {
    try {
      final deviceId = await getDeviceId();
      final bookmarked = await checkBookmark(deviceId, widget.article.id);
      if (!mounted) return;
      setState(() => _isBookmarked = bookmarked);
    } catch (e) {
      debugPrint('[ArticleScreen] bookmark check failed: $e');
    }
  }

  Future<void> _onToggleBookmark() async {
    if (_isBookmarkLoading) return;

    final wasBookmarked = _isBookmarked;
    setState(() {
      _isBookmarked = !wasBookmarked; // optimistic update
      _isBookmarkLoading = true;
    });

    try {
      final deviceId = await getDeviceId();
      if (wasBookmarked) {
        await removeBookmark(deviceId, widget.article.id);
      } else {
        await addBookmark(deviceId, widget.article.id);
      }
    } catch (e) {
      debugPrint('[ArticleScreen] bookmark toggle failed: $e');
      if (!mounted) return;
      setState(() => _isBookmarked = wasBookmarked); // revert on failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't update bookmark")),
      );
    } finally {
      if (mounted) setState(() => _isBookmarkLoading = false);
    }
  }

  // Strips <img> entirely (they weren't loading anyway) and unwraps <a> tags
  // (keeps the link text, drops the tag) so nothing renders as a broken
  // image or a tappable/underlined link.
  String _sanitizeHtml(String html) {
    return html
        .replaceAll(RegExp(r'<img[^>]*>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<a\b[^>]*>', caseSensitive: false), '')
        .replaceAll(RegExp(r'</a>', caseSensitive: false), '');
  }

  // NOTE: no longer strips ALL HTML tags — we keep paragraphs, headings,
  // lists, etc. so flutter_html can render real formatting. img/a tags
  // are stripped separately via _sanitizeHtml.
  Future<void> _extractContent() async {
    setState(() {
      _isExtracting = true;
      _extractError = null;
    });
    try {
      final result = await extractArticleContent(widget.article.id);
      final content = (result['content'] as String? ?? '').trim();
      if (!mounted) return;
      setState(() {
        _displayBody =
            content.isNotEmpty ? _sanitizeHtml(content) : widget.article.description;
        _isExtracting = false;
      });
    } catch (e) {
      debugPrint('[ArticleScreen] extraction failed: $e');
      if (!mounted) return;
      setState(() {
        _extractError = "Couldn't load full article";
        _displayBody = widget.article.description;
        _isExtracting = false;
      });
    }
  }

  Future<void> _onToggleListen() async {
    setState(() => _isReading = !_isReading);
    if (_isReading) {
      _readingProgressController
        ..reset()
        ..repeat();
    } else {
      _readingProgressController.stop();
    }
  }

  Future<void> _onToggleSummary() async {
    // already fetched once this session — just reopen the sheet, no re-fetch
    if (_summaryBullets.isNotEmpty) {
      _showSummarySheet();
      return;
    }

    setState(() => _isGeneratingSummary = true);
    try {
      final bullets = await fetchArticleSummary(widget.article.id);
      if (!mounted) return;
      setState(() {
        _summaryBullets = bullets;
        _isGeneratingSummary = false;
      });
      _showSummarySheet(); // pops up the instant it's ready — no scrolling needed
    } catch (e) {
      debugPrint('[ArticleScreen] summary failed: $e');
      if (!mounted) return;
      setState(() => _isGeneratingSummary = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't generate summary")),
      );
    }
  }

  void _showSummarySheet() {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                20,
                24,
                24 + MediaQuery.of(sheetContext).padding.bottom,
              ),
              decoration: BoxDecoration(
                color: colors.surface.withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: colors.textSec.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
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
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: Icon(Icons.close, color: colors.textSec),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ..._summaryBullets.map(
                    (bullet) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        '• $bullet',
                        style: TextStyle(color: colors.textSec, fontSize: 15, height: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final article = widget.article;

    return Scaffold(
      backgroundColor: colors.bg,
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: colors.bg,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
            ),
            actions: [
              _isBookmarkLoading
                  ? _GlassIconButton(
                      onTap: null,
                      child: const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : _GlassIconButton(
                      icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      iconColor: _isBookmarked ? colors.pri : Colors.white,
                      onTap: _onToggleBookmark,
                    ),
              const SizedBox(width: 16),
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.pri,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      article.category,
                      style: TextStyle(color: colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: colors.textSec),
                      const SizedBox(width: 5),
                      Text(article.timeAgo, style: TextStyle(color: colors.textSec)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    article.title,
                    style: TextStyle(
                      color: colors.textPri,
                      fontSize: 22,
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
                          style: TextStyle(color: colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.source,
                            style: TextStyle(color: colors.textPri, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${article.views} views • ${article.comments} comments',
                            style: TextStyle(color: colors.textSec),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),

                  if (_isExtracting) ...[
                    Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: colors.pri),
                          const SizedBox(height: 12),
                          Text('Fetching full story…', style: TextStyle(color: colors.textSec)),
                        ],
                      ),
                    ),
                  ] else ...[
                    if (_extractError != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 18, color: colors.textSec),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Showing summary only — $_extractError',
                                style: TextStyle(color: colors.textSec, fontSize: 13),
                              ),
                            ),
                            TextButton(onPressed: _extractContent, child: const Text('Retry')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Html(
                      data: _displayBody,
                      style: {
                        "body": Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          color: colors.textSec,
                          fontSize: FontSize(17),
                          lineHeight: LineHeight(1.8),
                        ),
                        "p": Style(
                          margin: Margins.only(bottom: 16),
                        ),
                        "h1, h2, h3": Style(
                          color: colors.textPri,
                          fontWeight: FontWeight.bold,
                          margin: Margins.only(top: 20, bottom: 10),
                        ),
                        "blockquote": Style(
                          padding: HtmlPaddings.only(left: 16),
                          border: Border(
                            left: BorderSide(color: colors.pri, width: 3),
                          ),
                          fontStyle: FontStyle.italic,
                          color: colors.textSec,
                        ),
                        "ul, ol": Style(
                          margin: Margins.only(bottom: 16, left: 8),
                        ),
                        "li": Style(
                          margin: Margins.only(bottom: 6),
                        ),
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _FloatingActionBar(
        colors: colors,
        isReading: _isReading,
        isGeneratingSummary: _isGeneratingSummary,
        progressController: _readingProgressController,
        onToggleListen: _onToggleListen,
        onToggleSummary: _onToggleSummary,
      ),
    );
  }
}

// Small circular glass button used for the back arrow / bookmark in the
// SliverAppBar, so they stay visible over bright hero images.
class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    this.icon,
    this.child,
    this.iconColor = Colors.white,
    required this.onTap,
  }) : assert(icon != null || child != null);

  final IconData? icon;
  final Widget? child;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.black.withOpacity(0.28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.white.withOpacity(0.18)),
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 38,
              height: 38,
              child: Center(
                child: child ?? Icon(icon, size: 18, color: iconColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingActionBar extends StatelessWidget {
  const _FloatingActionBar({
    required this.colors,
    required this.isReading,
    required this.isGeneratingSummary,
    required this.progressController,
    required this.onToggleListen,
    required this.onToggleSummary,
  });

  final AppColorsExtension colors;
  final bool isReading;
  final bool isGeneratingSummary;
  final AnimationController progressController;
  final VoidCallback onToggleListen;
  final VoidCallback onToggleSummary;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(58),
          child: BackdropFilter(
            // The blur is what actually creates the "glass" look — without
            // it this is just a translucent color, no matter the opacity.
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(58),
                border: Border.all(color: Colors.white.withOpacity(0.14)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onToggleListen,
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isReading
                                        ? Icons.pause_circle_filled
                                        : Icons.volume_up_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isReading ? 'Listening' : 'Listen',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isReading ? 'Playing article aloud' : 'Tap to play article',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.65),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _SummaryPillButton(
                        isLoading: isGeneratingSummary,
                        accent: colors.white,
                        onTap: onToggleSummary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AnimatedBuilder(
                    animation: progressController,
                    builder: (context, _) {
                      return _IndicatorBar(
                        progress: isReading ? progressController.value : null,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryPillButton extends StatelessWidget {
  const _SummaryPillButton({
    required this.isLoading,
    required this.accent,
    required this.onTap,
  });

  final bool isLoading;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: isLoading ? null : onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 130),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: accent, // solid pill CTA, same treatment as "Book Now"
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black87),
              )
            else
              const Icon(Icons.auto_awesome, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              isLoading ? 'Summarizing' : 'AI Summary',
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _IndicatorBar extends StatelessWidget {
  const _IndicatorBar({required this.progress});

  final double? progress;

  @override
  Widget build(BuildContext context) {
    const trackWidth = 120.0;
    return SizedBox(
      width: trackWidth,
      height: 4,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          if (progress != null)
            FractionallySizedBox(
              widthFactor: progress!.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}