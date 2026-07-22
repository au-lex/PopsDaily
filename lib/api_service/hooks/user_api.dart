import 'package:news_app/api_service/dio_client.dart';
import 'package:news_app/api_service/model/user.dart';



Future<User> fetchProfile() async {
  final res = await dio.get('/users/me');
  return User.fromJson(res.data);
}

Future<User> updateProfile({
  String? fullName,
  String? email,
  String? phone,
}) async {
  final res = await dio.patch('/users/me', data: {
    if (fullName != null && fullName.isNotEmpty) 'full_name': fullName,
    if (email != null && email.isNotEmpty) 'email': email,
    if (phone != null && phone.isNotEmpty) 'phone': phone,
  });
  return User.fromJson(res.data);
}

Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  await dio.post('/users/change-password', data: {
    'current_password': currentPassword,
    'new_password': newPassword,
  });
}