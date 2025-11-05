// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:oc_academy_app/core/di/register_module.dart' as _i923;
import 'package:oc_academy_app/core/network/dio_client.dart' as _i1011;
import 'package:oc_academy_app/data/datasources/remote/auth_remote_datasource.dart'
    as _i561;
import 'package:oc_academy_app/data/repositories/auth_repository_impl.dart'
    as _i1049;
import 'package:oc_academy_app/domain/repositories/auth_repository.dart'
    as _i643;
import 'package:oc_academy_app/domain/usecases/auth/login_usecase.dart'
    as _i535;
import 'package:oc_academy_app/domain/usecases/auth/logout_usecase.dart'
    as _i360;
import 'package:oc_academy_app/presentation/features/auth/bloc/auth_bloc.dart'
    as _i467;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i561.AuthRemoteDataSource>(
      () => _i561.AuthRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1011.DioClient>(() => _i1011.DioClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i643.AuthRepository>(
      () => _i1049.AuthRepositoryImpl(gh<_i561.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i535.LoginUseCase>(
      () => _i535.LoginUseCase(gh<_i643.AuthRepository>()),
    );
    gh.lazySingleton<_i360.LogoutUseCase>(
      () => _i360.LogoutUseCase(gh<_i643.AuthRepository>()),
    );
    gh.factory<_i467.AuthBloc>(
      () => _i467.AuthBloc(gh<_i535.LoginUseCase>(), gh<_i360.LogoutUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i923.RegisterModule {}
