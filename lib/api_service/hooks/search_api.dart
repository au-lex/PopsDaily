import 'package:news_app/api_service/dio_client.dart';
import 'package:news_app/api_service/model/models.dart';

class SearchParams {
  final String? q;
  final String? tag;
  final String? category;
  final int? feedId;
  final int page;
  final int limit;

  const SearchParams({
    this.q,
    this.tag,
    this.category,
    this.feedId,
    this.page = 1,
    this.limit = 20,
  });

  bool get isEmpty =>
      (q == null || q!.trim().isEmpty) &&
      (tag == null || tag!.trim().isEmpty) &&
      (category == null || category!.trim().isEmpty) &&
      feedId == null;

  SearchParams copyWith({
    String? q,
    String? tag,
    String? category,
    int? feedId,
    int? page,
    int? limit,
  }) {
    return SearchParams(
      q: q ?? this.q,
      tag: tag ?? this.tag,
      category: category ?? this.category,
      feedId: feedId ?? this.feedId,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toQuery() {
    return {
      if (q != null && q!.trim().isNotEmpty) 'q': q!.trim(),
      if (tag != null && tag!.trim().isNotEmpty) 'tag': tag!.trim(),
      if (category != null && category!.trim().isNotEmpty) 'category': category,
      if (feedId != null) 'feed_id': feedId,
      'page': page,
      'limit': limit,
    };
  }
}

Future<ArticleListResponse> searchArticles(SearchParams params) async {
  final res = await dio.get('/search', queryParameters: params.toQuery());
  return ArticleListResponse.fromJson(res.data);
}

Future<List<String>> fetchSearchTags() async {
  final res = await dio.get('/search/tags');
  return List<String>.from(res.data['tags'] as List);
}