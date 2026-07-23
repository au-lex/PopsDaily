import 'package:flutter/material.dart';
import 'package:news_app/api_service/model/models.dart' as api;
import 'package:news_app/model/news_model.dart';

/// Maps an API [api.Article] into the app's [NewsArticle] view model.
/// Shared between HomeScreen, SeeAllScreen, and anywhere else that
/// renders article lists — keeps the stripping/fallback logic in one place.
NewsArticle mapApiArticleToNewsArticle(api.Article article) {
  final sourceName = article.feed?.name ?? 'Unknown';
  final strippedContent =
      article.content.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  final strippedDescription =
      article.description.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  final readUrl = article.guid.isNotEmpty ? article.guid : article.link;

  return NewsArticle(
    id: article.id,
    title: article.title,
    description: strippedDescription,
    body: strippedContent.isNotEmpty ? strippedContent : strippedDescription,
    image: article.imageUrl ?? 'https://picsum.photos/seed/${article.id}/400/400',
    source: sourceName,
    sourceInitial: sourceName.isNotEmpty ? sourceName[0].toUpperCase() : '?',
    sourceColor: Colors.primaries[article.id % Colors.primaries.length],
    timeAgo: timeAgoFromDate(article.publishedAt),
    views: '',
    category: article.category ?? 'General',
    comments: '',
    link: readUrl,
  );
}

String timeAgoFromDate(DateTime? date) {
  if (date == null) return '';
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}