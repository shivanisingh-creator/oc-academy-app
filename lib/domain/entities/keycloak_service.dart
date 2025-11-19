// lib/data/auth_api/keycloak_service.dart

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:oc_academy_app/app/app_config.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/storage.dart';

class KeycloakTokenResponse {
  final String? accessToken;
  KeycloakTokenResponse({this.accessToken});
  factory KeycloakTokenResponse.fromJson(Map<String, dynamic> json) {
    return KeycloakTokenResponse(accessToken: json['access_token']);
  }
}

class KeycloakService {
  final ApiUtils _apiUtils = ApiUtils.instance;
  // In KeycloakService:
  final AppConfig _config = ApiUtils
      .instance
      .config; // Accesses the public getter  final TokenStorage _tokenStorage = TokenStorage(); // Use the storage service
  final TokenStorage _tokenStorage = TokenStorage();

  // --- Dynamic URL Construction ---
  String _getTokenUrl() {
    // Uses the environment-specific base URL and realm from AppConfig
    return '${_config.keycloakBaseUrl}/realms/${_config.keycloakRealm}${AppConfig.keycloakTokenPath}';
  }

  // --- API Call: Fetching the Access Token ---

  Future<KeycloakTokenResponse?> getKeycloakToken({
    required String clientId,
    required String clientSecret,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print("❌ No internet connectivity.");
      return KeycloakTokenResponse();
    }

    final tokenUrl = _getTokenUrl(); // Get the correct env URL dynamically

    try {
      // 1. Prepare Request Data (client_credentials grant type)
      final formData = {
        'grant_type': 'client_credentials',
        'client_id': clientId,
        'client_secret': clientSecret,
      };

      // 2. Execute POST Request using Dio instance from ApiUtils
      final responseData = await _apiUtils.post(
        data: formData,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {'Accept': 'application/json'},
        ),
        url: tokenUrl,
      );

      // 3. Process Success
      final tokenResponse = KeycloakTokenResponse.fromJson(
        responseData.data as Map<String, dynamic>,
      );

      // 4. Save the token using the dedicated storage service
      await _tokenStorage.saveAccessToken(tokenResponse.accessToken);

      print(
        "✅ Keycloak token fetched and saved for env: ${_config.environment.name}",
      );
      return tokenResponse;
    } catch (e) {
      // Error handling is centralized in ApiUtils/BaseRepo
      print("❌ Exception while fetching token: ${_apiUtils.handleError(e)}");
      return KeycloakTokenResponse();
    }
  }
}
