import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:oc_academy_app/core/error/exceptions.dart';
import 'package:oc_academy_app/core/error/failure.dart';
import 'package:oc_academy_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:oc_academy_app/domain/entities/auth/auth_user.dart';
import 'package:oc_academy_app/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AuthUser>> login(String email, String password) async {
    try {
      final authResponse = await remoteDataSource.login(email, password);
      return Right(AuthUser(token: authResponse.token));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
