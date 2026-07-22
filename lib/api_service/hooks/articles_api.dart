import 'package:news_app/api_service/dio_client.dart';
import 'package:news_app/api_service/model/models.dart';



Future<List<Article>> fetchArticles({int page = 1, String? category}) async {
  final res = await dio.get('/articles', queryParameters: {
    'page': page,
    if (category != null) 'category': category,
  });
  return (res.data['data'] as List).map((e) => Article.fromJson(e)).toList();
}

Future<Article> fetchArticle(int id) async {
  final res = await dio.get('/articles/$id');
  return Article.fromJson(res.data);
}

