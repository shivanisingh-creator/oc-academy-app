import 'package:logger/logger.dart';
import 'package:oc_academy_app/core/constants/api_endpoints.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/data/models/profession_response.dart';

class ProfessionRepository {
  final ApiUtils _apiUtils = ApiUtils.instance;
  final Logger _logger = Logger();

  Future<ProfessionResponse?> getProfessions() async {
    try {
      final response = await _apiUtils.get(
        url: ApiEndpoints.getProfessions,
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
