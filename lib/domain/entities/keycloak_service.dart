// lib/data/auth_api/keycloak_service.dart

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:oc_academy_app/app/app_config.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/storage.dart';

const int TOKEN_EXPIRATION_THRESHOLD = 60; // seconds

class KeycloakTokenResponse {
  final String? accessToken;
  final int? expiresIn; // Add expiresIn
  KeycloakTokenResponse({this.accessToken, this.expiresIn});
  factory KeycloakTokenResponse.fromJson(Map<String, dynamic> json) {
    return KeycloakTokenResponse(
      accessToken: json['access_token'],
      expiresIn: json['expires_in'],
    );
  }
}

class KeycloakService {
  final AppConfig _config;
  final TokenStorage _tokenStorage;

  KeycloakService({
    required AppConfig config,
    required TokenStorage tokenStorage,
  }) : _config = config,
       _tokenStorage = tokenStorage;

  // --- Dynamic URL Construction ---
  String _getTokenUrl() {
    // Uses the environment-specific base URL and realm from AppConfig
    return '${_config.keycloakBaseUrl}/realms/${_config.keycloakRealm}${AppConfig.keycloakTokenPath}';
  }

  // --- API Call: Fetching a new Access Token ---
  Future<String?> _fetchKeycloakToken({
    required String clientId,
    required String clientSecret,
  }) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print("❌ No internet connectivity.");
      return null;
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
      final responseData = await ApiUtils.instance.post(
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

      if (tokenResponse.accessToken != null &&
          tokenResponse.expiresIn != null) {
        // Calculate expiration date
        final expiryDate = DateTime.now().add(
          Duration(seconds: tokenResponse.expiresIn!),
        );
        // 4. Save the token and its expiration using the dedicated storage service
        await _tokenStorage.saveAccessToken(
          tokenResponse.accessToken,
          expiryDate,
        );

        print(
          "✅ Keycloak token fetched and saved for env: ${_config.environment.name}",
        );
        return tokenResponse.accessToken;
      }
      return null;
    } catch (e) {
      // Error handling is centralized in ApiUtils/BaseRepo
      print(
        "❌ Exception while fetching token: ${ApiUtils.instance.handleError(e)}",
      );
      return null;
    }
  }

  // --- Public method to get a valid Keycloak token, refreshing if needed ---
  Future<String?> getKeycloakToken({
    required String clientId,
    required String clientSecret,
  }) async {
    String? token = await _tokenStorage.getAccessToken();
    DateTime? expiry = await _tokenStorage.getAccessTokenExpiry();

    if (token == null || expiry == null) {
      // No token or expiry found, fetch a new one
      return await _fetchKeycloakToken(
        clientId: clientId,
        clientSecret: clientSecret,
      );
    }

    // Check if token is nearing expiration
    if (expiry
        .subtract(const Duration(seconds: TOKEN_EXPIRATION_THRESHOLD))
        .isBefore(DateTime.now())) {
      print("Keycloak token nearing expiration or expired, refreshing...");
      return await _fetchKeycloakToken(
        clientId: clientId,
        clientSecret: clientSecret,
      );
    }

    // Token is still valid
    return token;
  }
}
