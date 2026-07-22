import 'package:dio/dio.dart';
import 'token_storage.dart';

final dio = Dio(BaseOptions(baseUrl: 'https://lawyerly-tealess-annett.ngrok-free.dev/api'))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  ));