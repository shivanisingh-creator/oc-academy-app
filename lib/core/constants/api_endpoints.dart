class ApiEndpoints {
  ///base url for the prod
  static const String baseProdUrl = 'https://oca-commons-api.ocacademy.in/api';

  ///base url for the staging
  static const String baseStagingUrl = 'https://stg-oca-commons-api.ocacademy.in/api';

  ///base url for the pre-prod
  static const String basePreProdUrl = 'https://stg-oca-commons-api.ocacademy.in/api';

  // --- NEW: Keycloak Base URLs ---
    static const String keycloakProdUrl = 'https://keycloak.ocacademy.in/realms/ocacademy/';
    static const String keycloakPreProdUrl = 'https://pre-prod-keycloak.ocacademy.in/realms/stg-ocacademy/';
    static const String keycloakStagingUrl = 'https://stg-keycloak.ocacademy.in/realms/preprod-ocacademy/';
    
    // --- NEW: Keycloak Realm Names ---
    static const String keycloakProdRealm = 'prod-ocacademy';
    static const String keycloakPreProdRealm = 'preprod-ocacademy';
    static const String keycloakStagingRealm = 'stg-ocacademy';
}
