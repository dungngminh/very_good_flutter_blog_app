import 'package:authentication_data_source/authentication_data_source.dart';
import 'package:blog_data_source/blog_data_source.dart';
import 'package:bookmark_data_source/bookmark_data_source.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/di/di.config.dart';

final injector = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => injector.init();

Future<void> initServices() async {
  await Hive.openBox(HiveBox.userPrefs);
  final _bookmarkBox = await Hive.openBox<String>(HiveBox.bookmark);

  injector
    ..registerLazySingleton(
      Client.new,
    )
    ..registerLazySingleton(
      () => HttpClientHandler(
        client: injector<Client>(),
        baseUrl: FlavorConfig.instance.values.baseUrl,
      ),
    )
    ..registerLazySingleton(
      () => BlogRemoteDataSource(
        httpClientHandler: injector<HttpClientHandler>(),
      ),
    )
    ..registerLazySingleton(
      () => FirebaseStorageService(
        firebaseStorage: FirebaseStorage.instance,
      ),
    )
    ..registerLazySingleton(
      () => UserRemoteDataSource(
        httpClientHandler: injector<HttpClientHandler>(),
      ),
    )
    ..registerLazySingleton(
      () => BookmarkLocalDataSource(localBox: _bookmarkBox),
    )
    ..registerLazySingleton(
      () => BookmarkRemoteDataSource(
        httpClientHandler: injector<HttpClientHandler>(),
      ),
    )
    ..registerLazySingleton(
      () => AuthenticationRemoteDataSource(
        httpClientHandler: injector<HttpClientHandler>(),
      ),
    );
}
