import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:very_good_blog_app/data/firebase/storage_firebase_service.dart';
import 'package:very_good_blog_app/data/remote/good_blog_client.dart';

final injector = GetIt.instance;

void initServices() {
  injector
    ..registerLazySingleton(
      Client.new,
    )
    ..registerLazySingleton(
      () => FirebaseStorage.instance,
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
