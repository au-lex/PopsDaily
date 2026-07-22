class Feed {
  final int id;
  final String name;
  final String url;
  final String category;
  final bool active;

  Feed({
    required this.id,
    required this.name,
    required this.url,
    required this.category,
    required this.active,
  });

  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
    id: json['id'],
    name: json['name'] ?? '',
    url: json['url'] ?? '',
    category: json['category'] ?? '',
    active: json['active'] ?? false,
  );
}

class Article {
  final int id;
  final int feedId;
  final Feed? feed;
  final String title;
  final String link;
  final String description;
  final String content;
  final String? author;
  final String? category;
  final String? tags;
  final String? imageUrl;
  final DateTime? publishedAt;

  Article({
    required this.id,
    required this.feedId,
    this.feed,
    required this.title,
    required this.link,
    required this.description,
    required this.content,
    this.author,
    this.category,
    this.tags,
    this.imageUrl,
    this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    id: json['id'],
    feedId: json['feed_id'],
    feed: json['feed'] != null ? Feed.fromJson(json['feed']) : null,
    title: json['title'] ?? '',
    link: json['link'] ?? '',
    description: json['description'] ?? '',
    content: json['content'] ?? '',
    author: json['author'],
    category: json['category'],
    tags: json['tags'],
    imageUrl: json['image_url'],
    publishedAt: json['published_at'] != null
        ? DateTime.tryParse(json['published_at'])
        : null,
  );
}

class Bookmark {
  final int id;
  final int articleId;
  final Article? article;

  Bookmark({required this.id, required this.articleId, this.article});

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
    id: json['id'],
    articleId: json['article_id'],
    article: json['article'] != null ? Article.fromJson(json['article']) : null,
  );
}

class ArticleListResponse {
  final List<Article> articles;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ArticleListResponse({
    required this.articles,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ArticleListResponse.fromJson(Map<String, dynamic> json) {
    return ArticleListResponse(
      articles: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      totalPages: json['total_pages'] ?? 0,
    );
  }

  bool get hasMore => page < totalPages;
}