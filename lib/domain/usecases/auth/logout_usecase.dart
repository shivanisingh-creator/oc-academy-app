import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:oc_academy_app/core/error/failure.dart';
import 'package:oc_academy_app/domain/repositories/auth_repository.dart';
import 'package:oc_academy_app/domain/usecases/usecase.dart';

@lazySingleton
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
