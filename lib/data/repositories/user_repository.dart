import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:oc_academy_app/core/constants/api_endpoints.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:oc_academy_app/data/models/user/user_lite_response.dart';

class UserRepository {
  final ApiUtils _apiUtils = ApiUtils.instance;
  final TokenStorage _tokenStorage = TokenStorage();
  final Logger _logger = Logger();

  Future<UserLiteResponse?> getUserLite() async {
    try {
      final response = await _apiUtils.get(url: ApiEndpoints.getUserLite);

      if (response.statusCode == 200) {
        _logger.i("✅ Get User Lite successful.");
        final userLiteResponse = UserLiteResponse.fromJson(response.data);
        _logger.i("Response: ${userLiteResponse.response?.fullName}");
        return userLiteResponse;
      }
      return null;
    } catch (e) {
      _logger.e("❌ Exception during getUserLite: ${_apiUtils.handleError(e)}");
      return null;
    }
  }

  Future<bool> updateProfileDetails({
    String? fullName,
    String? qualification,
    List<int>? specialitiesOfInterestIds,
    String? profilePicPath,
  }) async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return false;
      }

      final Map<String, dynamic> userUpdateRequest = {
        if (fullName != null) "fullName": fullName,
        if (qualification != null) "qualification": qualification,
        if (specialitiesOfInterestIds != null)
          "specialitiesOfInterestIds": specialitiesOfInterestIds,
      };

      FormData formData = FormData.fromMap({
        "userUpdateRequest": jsonEncode(userUpdateRequest),
        if (profilePicPath != null)
          "profilePic": await MultipartFile.fromFile(
            profilePicPath,
            filename: profilePicPath.split('/').last,
          ),
      });

      final response = await _apiUtils.post(
        url: ApiEndpoints.updateProfile,
        data: formData,
        options: Options(
          headers: {
            'access-token': '2c5fcf97-eb32-41b0-89c6-2b79a1d3a181',
            'authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Update Profile Details successful.");
        return true;
      }
      return false;
    } catch (e) {
      _logger.e(
        "❌ Exception during updateProfileDetails: ${_apiUtils.handleError(e)}",
      );
      return false;
    }
  }
}
