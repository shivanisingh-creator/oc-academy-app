import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:oc_academy_app/core/constants/api_endpoints.dart';
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:oc_academy_app/data/models/home/banner_response.dart';
import 'package:oc_academy_app/data/models/home/global_partners_response.dart';
import 'package:oc_academy_app/data/models/home/testimonial_response.dart';
import 'package:oc_academy_app/data/models/home/specialty_response.dart';
import 'package:oc_academy_app/data/models/home/course_offering_response.dart';
import 'package:oc_academy_app/data/models/home/most_enrolled_response.dart';

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
    } catch (e, stackTrace) {
      _logger.e(
        "❌ Exception during getBanners: ${_apiUtils.handleError(e)}",
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<GlobalPartnersResponse?> getGlobalPartners() async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      // Get the saved API access token to use as hk-access-token
      final String? hkAccessToken = await _tokenStorage.getApiAccessToken();

      final response = await _apiUtils.get(
        url: ApiEndpoints.getGlobalPartners,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            if (hkAccessToken != null) 'hk-access-token': hkAccessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Get Global Partners successful.");
        final partnersResponse = GlobalPartnersResponse.fromJson(response.data);
        _logger.i("Response: ${partnersResponse.response?.length} partners");
        return partnersResponse;
      }
      return null;
    } catch (e, stackTrace) {
      _logger.e(
        "❌ Exception during getGlobalPartners: ${_apiUtils.handleError(e)}",
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<TestimonialResponse?> getTestimonials() async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      // Get the saved API access token to use as hk-access-token
      final String? hkAccessToken = await _tokenStorage.getApiAccessToken();

      final response = await _apiUtils.get(
        url: ApiEndpoints.getTestimonials,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            if (hkAccessToken != null) 'hk-access-token': hkAccessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Get Testimonials successful.");
        final testimonialResponse = TestimonialResponse.fromJson(response.data);
        _logger.i(
          "Response: ${testimonialResponse.response?.length} testimonials",
        );
        return testimonialResponse;
      }
      return null;
    } catch (e, stackTrace) {
      _logger.e(
        "❌ Exception during getTestimonials: ${_apiUtils.handleError(e)}",
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<SpecialtyResponse?> getSpecialties() async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      // Get the saved API access token to use as hk-access-token
      final String? hkAccessToken = await _tokenStorage.getApiAccessToken();

      final response = await _apiUtils.get(
        url: ApiEndpoints.getSpecialties,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            if (hkAccessToken != null) 'hk-access-token': hkAccessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Get Specialties successful.");
        final specialtyResponse = SpecialtyResponse.fromJson(response.data);
        _logger.i(
          "Response: ${specialtyResponse.response?.length} specialties",
        );
        return specialtyResponse;
      }
      return null;
    } catch (e, stackTrace) {
      _logger.e(
        "❌ Exception during getSpecialties: ${_apiUtils.handleError(e)}",
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<CourseOfferingResponse?> getCourseOfferings() async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      // Get the saved API access token to use as hk-access-token
      final String? hkAccessToken = await _tokenStorage.getApiAccessToken();

      final response = await _apiUtils.get(
        url: ApiEndpoints.getCourseOfferings,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            if (hkAccessToken != null) 'hk-access-token': hkAccessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Get Course Offerings successful.");
        final courseOfferingResponse = CourseOfferingResponse.fromJson(
          response.data,
        );
        _logger.i(
          "Response: ${courseOfferingResponse.response?.length} course offerings",
        );
        return courseOfferingResponse;
      }
      return null;
    } catch (e, stackTrace) {
      _logger.e(
        "❌ Exception during getCourseOfferings: ${_apiUtils.handleError(e)}",
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<MostEnrolledResponse?> getMostEnrolledCourses({
    required int type,
    int size = 5,
  }) async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      // Get the saved API access token to use as hk-access-token
      final String? hkAccessToken = await _tokenStorage.getApiAccessToken();

      // Construct the correct URL for course-api
      // Replace 'commons-api' with 'course-api' in the base URL
      String baseUrl = _apiUtils.config.baseUrl;
      String courseBaseUrl = baseUrl.replaceFirst('commons-api', 'course-api');

      // Ensure no double slashes
      if (courseBaseUrl.endsWith('/') &&
          ApiEndpoints.getMostEnrolled.startsWith('/')) {
        courseBaseUrl = courseBaseUrl.substring(0, courseBaseUrl.length - 1);
      }

      final String fullUrl = '$courseBaseUrl${ApiEndpoints.getMostEnrolled}';
      _logger.i("Fetching Most Enrolled Courses from: $fullUrl");

      final response = await _apiUtils.get(
        url: fullUrl,
        queryParameters: {'size': size, 'type': type},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            if (hkAccessToken != null) 'hk-access-token': hkAccessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Get Most Enrolled Courses (Type: $type) successful.");
        final mostEnrolledResponse = MostEnrolledResponse.fromJson(
          response.data,
        );
        _logger.i("Response: ${mostEnrolledResponse.response?.length} courses");
        return mostEnrolledResponse;
      }
      return null;
    } catch (e, stackTrace) {
      _logger.e(
        "❌ Exception during getMostEnrolledCourses: $e\n${_apiUtils.handleError(e)}",
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<String?> getReferralCode() async {
    try {
      final String? token = await _tokenStorage.getAccessToken();
      if (token == null) {
        _logger.e("❌ No access token found.");
        return null;
      }

      final String? hkAccessToken = await _tokenStorage.getApiAccessToken();

      // Construct the correct URL for commons-api (default base URL)
      String baseUrl = _apiUtils.config.baseUrl;
      if (baseUrl.endsWith('/')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 1);
      }
      final String fullUrl = '$baseUrl${ApiEndpoints.getReferralCode}';
      _logger.i("Fetching Referral Code from: $fullUrl");

      final response = await _apiUtils.get(
        url: fullUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            if (hkAccessToken != null) 'hk-access-token': hkAccessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        _logger.i("✅ Get Referral Code successful.");
        final referralCode = response.data['response'] as String?;
        _logger.i("Referral Code: $referralCode");
        return referralCode;
      }
      return null;
    } catch (e, stackTrace) {
      _logger.e(
        "❌ Exception during getReferralCode: $e\n${_apiUtils.handleError(e)}",
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
