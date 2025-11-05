import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String token;

  const AuthUser({required this.token});

  @override
  List<Object> get props => [token];
}
