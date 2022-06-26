import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/data/data.dart';

final injector = GetIt.instance;

Future<void> initServices() async {
  await Hive.openBox(HiveBox.userPrefs);
  final _bookmarkBox = await Hive.openBox(HiveBox.bookmark);

  injector
    ..registerLazySingleton(
      Client.new,
    )
    ..registerLazySingleton(
      () => FirebaseStorage.instance,
    )
    ..registerLazySingleton(
      () => BookmarkLocalBox(
        bookmarkBox: _bookmarkBox,
      ),
    )
    ..registerLazySingleton(
      () => GoodBlogClient(
        client: injector<Client>(),
      ),
    )
    ..registerLazySingleton(
      () => StorageFirebaseService(
        firebaseStorage: injector<FirebaseStorage>(),
      ),
    );
}
