import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:oc_academy_app/core/error/failure.dart';
import 'package:oc_academy_app/domain/entities/auth/auth_user.dart';
import 'package:oc_academy_app/domain/repositories/auth_repository.dart';
import 'package:oc_academy_app/domain/usecases/usecase.dart';

@lazySingleton
class LoginUseCase implements UseCase<AuthUser, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
