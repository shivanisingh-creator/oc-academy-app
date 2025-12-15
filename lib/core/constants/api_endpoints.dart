class ApiEndpoints {
  ///base url for the prod
  static const String baseProdUrl =
      'https://preprod-oca-commons-api.ocacademy.in/api';

  ///base url for the staging
  static const String baseStagingUrl =
      'https://stg-oca-commons-api.ocacademy.in/api/';

  ///base url for the pre-prod
  static const String basePreProdUrl =
      'https://preprod-oca-commons-api.ocacademy.in/api/';

  // --- NEW: Keycloak Base URLs ---
  static const String keycloakProdUrl = 'https://keycloak.ocacademy.in';
  static const String keycloakPreProdUrl =
      'https://preprod-keycloak.ocacademy.in/';
  static const String keycloakStagingUrl = 'https://stg-keycloak.ocacademy.in';

  // --- NEW: Keycloak Realm Names ---
  static const String keycloakProdRealm = 'prod-ocacademy';
  static const String keycloakPreProdRealm = 'stg-ocacademy';
  static const String keycloakStagingRealm = 'stg-ocacademy';

  // --- NEW: Keycloak Client IDs ---
  static const String keycloakProdClientId = 'oca-app';
  static const String keycloakPreProdClientId = 'oca-app';
  static const String keycloakStagingClientId = 'oca-app';

  // --- NEW: Keycloak Client Secrets ---
  static const String keycloakProdClientSecret =
      'Eik0J5noiLWCqvLTzBxCkuEc0LAXBMNy';
  static const String keycloakPreProdClientSecret =
      'Eik0J5noiLWCqvLTzBxCkuEc0LAXBMNy';
  static const String keycloakStagingClientSecret =
      'SMA9xI3AVIwfVAWiXS7DMbEYi339ZxAs';

  ///Login APIs
  static const String signupLoginMobile = '/auth/signupLogin/mobile';
  static const String verifyOtp = '/auth/verifyOtp';
  static const String createProfile = '/auth/createProfile';
  static const String signupLoginGoogle = '/auth/google/login';
  static const String getUserLite = '/auth/getUserLite';
  static const String getUserCourses = '/home/userCourses';
  static const String getRecentActivity = '/dashboard/getRecentActivity';
  static const String getCourseProgress = '/dashboard/courseProgress';

  ///Home APIs
  static const String getBanners = '/home/banner/getAll';
  static const String getGlobalPartners = '/home/globalPartners';
  static const String getTestimonials = '/home/testimonial/getAll';
  static const String getSpecialties = '/home/oc/specialities?isHome=false';
  static const String getCourseOfferings = '/home/courseOfferings';
  static const String getMostEnrolled = '/home/mostEnrolled';
  static const String getReferralCode = '/referral';
}
