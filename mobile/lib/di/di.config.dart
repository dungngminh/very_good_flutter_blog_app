// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:chopper/chopper.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../data/remote/auth/auth_service.dart' as _i4;
import 'modules/network_module.dart' as _i5;

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
    final networkModule = _$NetworkModule();
    gh.factory<String>(
      () => networkModule.baseUrl,
      instanceName: 'baseUrl',
    );
    gh.lazySingleton<_i3.ChopperClient>(
      () => networkModule
          .unAuthChopperClient(gh<String>(instanceName: 'baseUrl')),
      instanceName: 'unAuthClient',
    );
    gh.lazySingleton<_i3.ChopperClient>(
      () =>
          networkModule.authChopperClient(gh<String>(instanceName: 'baseUrl')),
      instanceName: 'authClient',
    );
    gh.lazySingleton<_i4.AuthService>(() => _i4.AuthService.create(
        gh<_i3.ChopperClient>(instanceName: 'unAuthClient')));
    return this;
  }
}

class _$NetworkModule extends _i5.NetworkModule {}
