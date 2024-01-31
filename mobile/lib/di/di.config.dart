// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chopper/chopper.dart' as _i5;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/datasources/local/user_secure_storage.dart' as _i4;
import '../data/datasources/remote/auth/auth_service.dart' as _i6;
import '../data/repositories/auth_repository_impl.dart' as _i8;
import '../domain/repositories/auth_repository.dart' as _i7;
import 'modules/local_module.dart' as _i9;
import 'modules/network_module.dart' as _i10;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final localModule = _$LocalModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i3.FlutterSecureStorage>(() => localModule.secureStorage);
    gh.factory<String>(
      () => networkModule.baseUrl,
      instanceName: 'baseUrl',
    );
    gh.lazySingleton<_i4.UserSecureStorage>(() => _i4.UserSecureStorageImpl(
        secureStorage: gh<_i3.FlutterSecureStorage>()));
    gh.lazySingleton<_i5.ChopperClient>(
      () => networkModule
          .unAuthChopperClient(gh<String>(instanceName: 'baseUrl')),
      instanceName: 'unAuthClient',
    );
    gh.lazySingleton<_i5.ChopperClient>(
      () =>
          networkModule.authChopperClient(gh<String>(instanceName: 'baseUrl')),
      instanceName: 'authClient',
    );
    gh.lazySingleton<_i6.AuthService>(() => _i6.AuthService.create(
        gh<_i5.ChopperClient>(instanceName: 'unAuthClient')));
    gh.lazySingleton<_i7.AuthRepository>(() => _i8.AuthRepositoryImpl(
          authService: gh<_i6.AuthService>(),
          secureStorage: gh<_i4.UserSecureStorage>(),
        ));
    return this;
  }
}

class _$LocalModule extends _i9.LocalModule {}

class _$NetworkModule extends _i10.NetworkModule {}
