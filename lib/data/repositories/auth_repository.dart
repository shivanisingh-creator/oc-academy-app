import 'package:dio/dio.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:oc_academy_app/data/models/auth/signup_login_mobile_response.dart';

class AuthRepository {
  final ApiUtils _apiUtils = ApiUtils.instance;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<SignupLoginMobileResponse?> signupLoginMobile(String mobileNumber) async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        print("❌ No access token found.");
        return null;
      }

      final String fullUrl = '${_apiUtils.config.baseUrl}/auth/signupLogin/mobile';
      print("Calling API: $fullUrl");

      final response = await _apiUtils.post(
        url: '/auth/signupLogin/mobile',
        data: {
          "mobileNumber": mobileNumber,
          "appleUserId": "string" /// TODO: Handle this properly
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print("✅ OTP sent successfully.");
        final signupResponse = SignupLoginMobileResponse.fromJson(response.data);
        print("Response: ${signupResponse.response}");
        return signupResponse;
      }
      return null;
    } catch (e) {
      print("❌ Exception during signupLoginMobile: ${_apiUtils.handleError(e)}");
      return null;
    }
  }
}
