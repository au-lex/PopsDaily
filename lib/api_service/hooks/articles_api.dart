import 'package:news_app/api_service/dio_client.dart';
import 'package:news_app/api_service/model/models.dart';



Future<List<Article>> fetchArticles({int page = 1, String? category, required int limit}) async {
  final res = await dio.get('/articles', queryParameters: {
    'page': page,
    'limit': limit,
    if (category != null) 'category': category,
  });
  return (res.data['data'] as List).map((e) => Article.fromJson(e)).toList();
}

Future<Article> fetchArticle(int id) async {
  final res = await dio.get('/articles/$id');
  return Article.fromJson(res.data);
}

Future<ArticleListResponse> fetchArticlesBySourceId(
  int sourceId, {
  int page = 1,
  int limit = 20,
  String? category,
}) async {
  final res = await dio.get('/articles/source-id/$sourceId', queryParameters: {
    'page': page,
    'limit': limit,
    if (category != null) 'category': category,
  });
  return ArticleListResponse.fromJson(res.data);
}

// articles_api.dart — add this
Future<Map<String, dynamic>> extractArticleContent(int id) async {
  final res = await dio.get('/articles/$id/extract');
  return res.data as Map<String, dynamic>;
}

// GET /articles/:id/summary — returns 3 GPT-generated bullet points.
// Backend caches the result on the article row, so repeat calls for the
// same article are instant and don't hit OpenAI again.
Future<List<String>> fetchArticleSummary(int id) async {
  final res = await dio.get('/articles/$id/summary');
  return List<String>.from(res.data['summary'] as List);
}