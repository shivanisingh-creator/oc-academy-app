import 'package:dartz/dartz.dart';
import 'package:oc_academy_app/core/error/failure.dart';
import 'package:oc_academy_app/domain/entities/auth/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> login(String email, String password);
  Future<Either<Failure, void>> logout();
}
