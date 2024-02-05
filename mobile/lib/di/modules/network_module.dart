import 'package:chopper/chopper.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkModule {
  @Named('baseUrl')
  String get baseUrl => const String.fromEnvironment('BASE_URL');

  @Named('unAuthClient')
  @lazySingleton
  ChopperClient unAuthChopperClient(@Named('baseUrl') String baseUrl) {
    return ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      converter: const JsonConverter(),
      interceptors: [
        CurlInterceptor(),
        HttpLoggingInterceptor(),
      ],
    );
  }

  @Named('authClient')
  @lazySingleton
  ChopperClient authChopperClient(@Named('baseUrl') String baseUrl) {
    return ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      converter: const JsonConverter(),
      interceptors: [
        CurlInterceptor(),
        HttpLoggingInterceptor(),
      ],
    );
  }
}
