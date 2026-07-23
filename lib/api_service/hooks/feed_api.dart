import 'package:news_app/api_service/dio_client.dart';
import 'package:news_app/api_service/model/models.dart';

Future<List<Feed>> fetchFeeds({String? category, bool? active}) async {
  final res = await dio.get('/feeds', queryParameters: {
    if (category != null) 'category': category,
    if (active != null) 'active': active,
  });
  return (res.data as List).map((e) => Feed.fromJson(e)).toList();
}

Future<Feed> fetchFeed(int id) async {
  final res = await dio.get('/feeds/$id');
  return Feed.fromJson(res.data);
}

Future<List<FeedSource>> fetchFeedSources() async {
  final res = await dio.get('/feeds/sources');
  return (res.data as List).map((e) => FeedSource.fromJson(e)).toList();
}