import 'package:dio/dio.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:logger/logger.dart';
import 'package:oc_academy_app/domain/entities/keycloak_service.dart';
import 'package:oc_academy_app/app/app_config.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Logger _logger;
  final KeycloakService _keycloakService;
  final AppConfig _config;

  AuthInterceptor(
    this._tokenStorage,
    this._logger,
    this._keycloakService,
    this._config,
  );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Ensure we have a fresh Keycloak token before proceeding
    // Avoid infinite loop: Don't fetch token if we are already making a token request
    if (!options.path.contains('token')) {
      final String? keycloakToken = await _keycloakService.getKeycloakToken(
        clientId: _config.keycloakClientId,
        clientSecret: _config.keycloakClientSecret,
      );

      if (keycloakToken != null) {
        options.headers['Authorization'] = 'Bearer $keycloakToken';
      } else {
        _logger.w(
          'Keycloak token not available for request to ${options.path}',
        );
      }
    }

    final hkAccessToken = await _tokenStorage.getApiAccessToken();
    if (hkAccessToken != null) {
      options.headers['hk-access-token'] = hkAccessToken;
    }

    _logger.i('Sending request: ${options.method} ${options.path}');
    _logger.i('Headers: ${options.headers}');

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      _logger.e('Received 401 Unauthorized. Clearing tokens.');
      await _tokenStorage.deleteAccessToken();
      await _tokenStorage.deleteApiAccessToken();
      // Optionally, you could add logic here to navigate to login screen
      // but this needs BuildContext, which is not available in interceptor.
      // This should be handled by the BLoC/UI layer reacting to a logout event
      // or by re-authentication logic.
    }
    super.onError(err, handler);
  }
}
