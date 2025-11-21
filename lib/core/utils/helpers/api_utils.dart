// lib/core/api_utils.dart

import 'package:dio/dio.dart';
import 'package:oc_academy_app/app/app_config.dart';

class ApiUtils {
  final Dio _dio;
  final AppConfig _config;

  // 🚨 FIX: Add a public getter to expose the configuration 🚨
  // This allows external classes (like KeycloakService) to access the environment settings.
  AppConfig get config => _config; 

  // 1. Private Constructor: Only callable internally
  ApiUtils._internal(this._config) 
      : _dio = Dio(BaseOptions(
          baseUrl: _config.baseUrl, // Base URL is dynamically loaded from config
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          // You could add an AuthInterceptor here using _config.apiKey
        ));

  // 2. Static Instance Holder (nullable until initialized)
  static ApiUtils? _instance;

  // 3. Initialization Method: Called once in main()
  static void initialize(AppConfig config) {
    _instance ??= ApiUtils._internal(config);
  }

  // 4. Singleton Getter: Used everywhere in the app
  static ApiUtils get instance {
    if (_instance == null) {
      throw Exception("ApiUtils must be initialized by calling ApiUtils.initialize(config) in main()");
    }
    return _instance!;
  }

  // --- Core Dio Wrapper Methods ---

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _instance!._dio.get( // Use the internal _dio instance
      url,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _instance!._dio.post( // Use the internal _dio instance
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // --- Error Handling Methods (Unchanged) ---

  String getNetworkError() {
    return 'Please check your internet connection.';
  }

  String handleError(dynamic error) {
    String message = 'An unknown error occurred.';

    if (error is DioException) {
      if (error.type == DioExceptionType.badResponse && error.response != null) {
        if (error.response!.data is Map<String, dynamic>) {
          message = error.response!.data['message'] ?? 'Server Error: ${error.response!.statusCode}';
        } else {
          message = error.response!.data.toString();
        }
      } else if (error.type == DioExceptionType.connectionTimeout) {
        message = 'Request timed out.';
      } else if (error.type == DioExceptionType.unknown) {
         message = 'Network error. Could not connect to the server.';
      }
    }
    return message;
  }
}

// Global instance to match your previous structure:
final apiUtils = ApiUtils.instance;