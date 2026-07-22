import 'package:news_app/api_service/dio_client.dart';
import 'package:news_app/api_service/token_storage.dart';
import 'package:news_app/api_service/model/user.dart';

Future<User> signup({
  required String fullName,
  required String email,
  required String password,
  required String phone,
}) async {
  final res = await dio.post('/auth/signup', data: {
    'full_name': fullName,
    'email': email,
    'password': password,
    'phone': phone,
  });
  await saveToken(res.data['token']);
  return User.fromJson(res.data['user']);
}

Future<User> login(String email, String password) async {
  final res = await dio.post('/auth/login', data: {'email': email, 'password': password});
  await saveToken(res.data['token']);
  return User.fromJson(res.data['user']);
}

Future<String> forgotPassword(String email) async {
  final res = await dio.post('/auth/forgot-password', data: {'email': email});
  return res.data['message'];
}

Future<String> resendOtp(String email) async {
  final res = await dio.post('/auth/resend-otp', data: {'email': email});
  return res.data['message'];
}

Future<String> resetPassword(String email, String otp, String newPassword) async {
  final res = await dio.post('/auth/reset-password', data: {
    'email': email,
    'otp': otp,
    'new_password': newPassword,
  });
  return res.data['message'];
}

Future<User> getProfile() async {
  final res = await dio.get('/users/me');
  return User.fromJson(res.data);
}

Future<void> logout() => clearToken();