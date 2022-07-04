import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();

  static const jwt = 'jwt';
  static const userId = 'id';
  static const fcmToken = 'fcm';

  static Future<String?> getValueByKey(String key) {
    return _storage.read(key: key);
  }

  static Future<void> writeValueToKey({
    required String key,
    required String value,
  }) {
    return _storage.write(value: value, key: key);
  }

  static Future<void> deleteValueFromKey(String key) {
    return _storage.delete(key: key);
  }
}
