import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

const accessTokenKey = 'ACCESS_TOKEN';
const userIdKey = 'USER_ID';

abstract class UserSecureStorage {
  Future<String?> get accessToken;

  Future<String?> get userId;

  Future<void> setUserId(String userId);

  Future<void> setAccessToken(String accessToken);

  Future<void> removeAllKeys();
}

@LazySingleton(as: UserSecureStorage)
class UserSecureStorageImpl implements UserSecureStorage {
  UserSecureStorageImpl({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  @override
  Future<String?> get accessToken => _secureStorage.read(key: accessTokenKey);

  @override
  Future<String?> get userId => _secureStorage.read(key: userIdKey);

  @override
  Future<void> setAccessToken(String accessToken) =>
      _secureStorage.write(key: accessTokenKey, value: accessToken);

  @override
  Future<void> setUserId(String userId) =>
      _secureStorage.write(key: userIdKey, value: userId);

  @override
  Future<void> removeAllKeys() => _secureStorage.deleteAll();
}
