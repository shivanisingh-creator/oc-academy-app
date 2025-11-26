import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:oc_academy_app/core/constants/api_endpoints.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:oc_academy_app/data/models/home/banner_response.dart';

class HomeRepository {
  final ApiUtils _apiUtils = ApiUtils.instance;
  final TokenStorage _tokenStorage = TokenStorage();
  final Logger _logger = Logger();

  Future<BannerResponse?> getBanners() async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      // Get the saved API access token to use as hk-access-token
      final String? hkAccessToken = await _tokenStorage.getApiAccessToken();

      final response = await _apiUtils.get(
        url: ApiEndpoints.getBanners,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            if (hkAccessToken != null) 'hk-access-token': hkAccessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Get Banners successful.");
        final bannerResponse = BannerResponse.fromJson(response.data);
        _logger.i("Response: ${bannerResponse.response?.length} banners");
        return bannerResponse;
      }
      return null;
    } catch (e) {
      _logger.e("❌ Exception during getBanners: ${_apiUtils.handleError(e)}");
      return null;
    }
  }
}
