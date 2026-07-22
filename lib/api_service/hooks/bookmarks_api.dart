import 'package:news_app/api_service/dio_client.dart';
import 'package:news_app/api_service/model/models.dart';

Future<List<Bookmark>> fetchBookmarks(String deviceId, {int page = 1}) async {
  final res = await dio.get('/bookmarks', queryParameters: {'device_id': deviceId, 'page': page});
  return (res.data['data'] as List).map((e) => Bookmark.fromJson(e)).toList();
}

Future<void> addBookmark(String deviceId, int articleId) =>
    dio.post('/bookmarks', data: {'device_id': deviceId, 'article_id': articleId});

Future<void> removeBookmark(String deviceId, int articleId) =>
    dio.delete('/bookmarks/$articleId', queryParameters: {'device_id': deviceId});

Future<bool> checkBookmark(String deviceId, int articleId) async {
  final res = await dio.get('/bookmarks/check/$articleId', queryParameters: {'device_id': deviceId});
  return res.data['bookmarked'];
}