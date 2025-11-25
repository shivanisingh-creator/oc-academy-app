class ApiEndpoints {
  ///base url for the prod
  static const String baseProdUrl = 'https://oca-commons-api.ocacademy.in/api';

  ///base url for the staging
  static const String baseStagingUrl = 'https://stg-oca-commons-api.ocacademy.in/api/';

  ///base url for the pre-prod
  static const String basePreProdUrl = 'https://stg-oca-commons-api.ocacademy.in/api';

    // --- NEW: Keycloak Base URLs ---
    static const String keycloakProdUrl = 'https://keycloak.ocacademy.in';
    static const String keycloakPreProdUrl = 'https://pre-prod-keycloak.ocacademy.in';
    static const String keycloakStagingUrl = 'https://stg-keycloak.ocacademy.in';
    
    // --- NEW: Keycloak Realm Names ---
    static const String keycloakProdRealm = 'prod-ocacademy';
    static const String keycloakPreProdRealm = 'preprod-ocacademy';
    static const String keycloakStagingRealm = 'stg-ocacademy';

    // --- NEW: Keycloak Client IDs ---
    static const String keycloakProdClientId = 'oca-app';
    static const String keycloakPreProdClientId = 'oca-app';
    static const String keycloakStagingClientId = 'oca-app';

    // --- NEW: Keycloak Client Secrets ---
    static const String keycloakProdClientSecret = 'Eik0J5noiLWCqvLTzBxCkuEc0LAXBMNy';
    static const String keycloakPreProdClientSecret = 'YRwwmADpGd5lvvHPsMOWbqwJrlaZWwnd';
    static const String keycloakStagingClientSecret = 'SMA9xI3AVIwfVAWiXS7DMbEYi339ZxAs';

    ///Login APIs
      static const String signupLoginMobile = '/auth/signupLogin/mobile';
      static const String verifyOtp = '/auth/verifyOtp';
      static const String createProfile = '/auth/createProfile';
      static const String signupLoginGoogle = '/auth/google/login';

    
}
