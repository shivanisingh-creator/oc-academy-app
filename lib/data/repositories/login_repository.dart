import 'package:logger/logger.dart';
import 'package:oc_academy_app/core/constants/api_endpoints.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:oc_academy_app/data/models/auth/create_profile_request.dart';
import 'package:oc_academy_app/data/models/auth/create_profile_response.dart';
import 'package:oc_academy_app/data/models/auth/signup_login_mobile_response.dart';
import 'package:oc_academy_app/data/models/auth/verify_otp_request.dart';
import 'package:oc_academy_app/data/models/auth/verify_otp_response.dart';

import 'package:oc_academy_app/data/models/auth/signup_login_google_request.dart';
import 'package:oc_academy_app/data/models/auth/signup_login_google_response.dart';

class AuthRepository {
  final ApiUtils _apiUtils = ApiUtils.instance;
  final TokenStorage _tokenStorage = TokenStorage();
  final Logger _logger = Logger();

  Future<void> logout() async {
    try {
      final String? token = await _tokenStorage.getAccessToken();

      if (token == null) {
        _logger.e("❌ No access token found.");
        // Still clear local storage just in case
        await _tokenStorage.deleteAccessToken();
        await _tokenStorage.deleteApiAccessToken();
        return;
      }

      await _apiUtils.get(url: ApiEndpoints.logout);

      await _tokenStorage.deleteAccessToken();
      await _tokenStorage.deleteApiAccessToken();
      _logger.i("✅ User logged out successfully.");
    } catch (e) {
      _logger.e("❌ Exception during logout: ${_apiUtils.handleError(e)}");
      // Still clear local storage even if API call fails
      await _tokenStorage.deleteAccessToken();
      await _tokenStorage.deleteApiAccessToken();
      // Rethrow the exception to be handled by the BLoC
      rethrow;
    }
  }

  Future<SignupLoginGoogleResponse?> signInWithGoogle(
    SignupLoginGoogleRequest request,
  ) async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      final response = await _apiUtils.post(
        url: ApiEndpoints.signupLoginGoogle,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Google Sign-In successful.");
        final googleSignInResponse = SignupLoginGoogleResponse.fromJson(
          response.data,
        );
        _logger.i("Response: ${googleSignInResponse.response}");
        return googleSignInResponse;
      }
      return null;
    } catch (e) {
      _logger.e(
        "❌ Exception during signInWithGoogle: ${_apiUtils.handleError(e)}",
      );
      return null;
    }
  }

  Future<SignupLoginMobileResponse?> signupLoginMobile(
    String mobileNumber,
  ) async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      final String fullUrl =
          '${_apiUtils.config.baseUrl}/auth/signupLogin/mobile';
      _logger.i("Calling API: $fullUrl");

      final response = await _apiUtils.post(
        url: ApiEndpoints.signupLoginMobile,
        data: {
          "mobileNumber": mobileNumber,
          "appleUserId": "",

          /// TODO: Handle this properly
        },
      );

      if (response.statusCode == 200) {
        _logger.i("✅ OTP sent successfully.");
        final signupResponse = SignupLoginMobileResponse.fromJson(
          response.data,
        );
        _logger.i("Response: ${signupResponse.response}");
        return signupResponse;
      }
      return null;
    } catch (e) {
      _logger.e(
        "❌ Exception during signupLoginMobile: ${_apiUtils.handleError(e)}",
      );
      return null;
    }
  }

  Future<VerifyOtpResponse?> verifyOtp(VerifyOtpRequest request) async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      final response = await _apiUtils.post(
        url: ApiEndpoints.verifyOtp,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ OTP verified successfully.");
        final verifyOtpResponse = VerifyOtpResponse.fromJson(response.data);
        _logger.i("Response: ${verifyOtpResponse.response}");
        return verifyOtpResponse;
      }
      return null;
    } catch (e) {
      _logger.e("❌ Exception during verifyOtp: ${_apiUtils.handleError(e)}");
      return null;
    }
  }

  Future<CreateProfileResponse?> createProfile(
    CreateProfileRequest request,
  ) async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      final response = await _apiUtils.post(
        url: ApiEndpoints.createProfile,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Profile created successfully.");
        final createProfileResponse = CreateProfileResponse.fromJson(
          response.data,
        );
        _logger.i("Response: ${createProfileResponse.response}");
        return createProfileResponse;
      }
      return null;
    } catch (e) {
      final errorMessage = _apiUtils.handleError(e);
      _logger.e("❌ Exception during createProfile: $errorMessage");
      throw errorMessage;
    }
  }
}
