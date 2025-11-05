import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DioClient {
  final Dio dio;

  DioClient(this.dio) {
    dio.options.baseUrl = 'https://api.example.com'; // Replace with your API base URL
    dio.interceptors.add(LogInterceptor(responseBody: true));
  }
}
