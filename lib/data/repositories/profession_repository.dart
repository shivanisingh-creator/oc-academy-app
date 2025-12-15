import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:oc_academy_app/core/constants/api_endpoints.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:oc_academy_app/data/models/profession_response.dart';

class ProfessionRepository {
  final ApiUtils _apiUtils = ApiUtils.instance;
  final TokenStorage _tokenStorage = TokenStorage();
  final Logger _logger = Logger();

  Future<ProfessionResponse?> getProfessions() async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      // Get the saved API access token to use as hk-access-token
      final String? hkAccessToken = await _tokenStorage.getApiAccessToken();

      final response = await _apiUtils.get(
        url: ApiEndpoints.getProfessions,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            if (hkAccessToken != null) 'hk-access-token': hkAccessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Get Professions successful.");
        final professionResponse = ProfessionResponse.fromJson(response.data);
        return professionResponse;
      }
      return null;
    } catch (e) {
      _logger.e(
        "❌ Exception during getProfessions: ${_apiUtils.handleError(e)}",
      );
      return null;
    }
  }
}
