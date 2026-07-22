import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _tokenKey = 'auth_token';
const _deviceIdKey = 'device_id';

Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_tokenKey, token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_tokenKey);
}

Future<void> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_tokenKey);
}

Future<String> getDeviceId() async {
  final prefs = await SharedPreferences.getInstance();
  var deviceId = prefs.getString(_deviceIdKey);
  if (deviceId == null) {
    deviceId = const Uuid().v4();
    await prefs.setString(_deviceIdKey, deviceId);
  }
  return deviceId;
}