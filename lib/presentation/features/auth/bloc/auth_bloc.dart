import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:oc_academy_app/domain/usecases/auth/login_usecase.dart';
import 'package:oc_academy_app/domain/usecases/auth/logout_usecase.dart';
import 'package:oc_academy_app/domain/usecases/usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc(this.loginUseCase, this.logoutUseCase) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final failureOrUser = await loginUseCase(LoginParams(email: event.email, password: event.password));
      failureOrUser.fold(
        (failure) => emit(AuthFailure('Login failed')),
        (user) => emit(AuthSuccess(user.token)),
      );
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      final failureOrSuccess = await logoutUseCase(NoParams());
      failureOrSuccess.fold(
        (failure) => emit(AuthFailure('Logout failed')),
        (_) => emit(AuthInitial()),
      );
    });
  }
}
