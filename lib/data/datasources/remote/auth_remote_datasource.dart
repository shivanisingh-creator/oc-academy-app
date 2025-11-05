import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oc_academy_app/data/models/auth/auth_response_model.dart';
import 'package:oc_academy_app/core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final response = await dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    // Simulate a network call
    await Future.delayed(const Duration(seconds: 1));
  }
}
