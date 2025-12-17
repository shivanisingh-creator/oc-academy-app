import 'package:logger/logger.dart';
import 'package:oc_academy_app/core/constants/api_endpoints.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/data/models/user/user_lite_response.dart';

class UserRepository {
  final ApiUtils _apiUtils = ApiUtils.instance;
  final Logger _logger = Logger();

  Future<UserLiteResponse?> getUserLite() async {
    try {
      final response = await _apiUtils.get(
        url: ApiEndpoints.getUserLite,
      );

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
}
