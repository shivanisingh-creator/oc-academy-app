// lib/config/app_config.dart

import 'package:oc_academy_app/core/constants/api_endpoints.dart';
import 'package:oc_academy_app/core/constants/legal_urls.dart';

enum Environment { production, preprod, staging }

class AppConfig {
  final Environment environment;
  final String baseUrl;
  final String apiKey;

  // --- New Keycloak Fields ---
  final String keycloakBaseUrl;
  final String keycloakRealm;
  final String keycloakClientId;
  final String keycloakClientSecret;
  final String termsOfUseUrl;
  final String privacyPolicyUrl;
  final String aboutUsUrl;
  final String contactUsUrl;
  final String faqUrl;
  final String logbookUrl;
  // ---------------------------

  // Define static Keycloak paths (these are constant across all Keycloak servers)
  static const String keycloakTokenPath = '/protocol/openid-connect/token';
  static const String keycloakAuthPath = '/protocol/openid-connect/auth';

  AppConfig({
    required this.environment,
    required this.baseUrl,
    required this.apiKey,
    // --- New required Keycloak fields ---
    required this.keycloakBaseUrl,
    required this.keycloakRealm,
    required this.keycloakClientId,
    required this.keycloakClientSecret,
    required this.termsOfUseUrl,
    required this.privacyPolicyUrl,
    required this.aboutUsUrl,
    required this.contactUsUrl,
    required this.faqUrl,
    required this.logbookUrl,
  });

  // Factory method to initialize config based on a passed environment string
  factory AppConfig.forEnvironment(String env) {
    switch (env.toLowerCase()) {
      case 'production':
        return AppConfig._prod();
      case 'preprod':
        return AppConfig._preprod();
      case 'staging':
      default:
        return AppConfig._staging();
    }
  }

  // --- Private Constructors for Environment-Specific Values ---

  // Private constructor for Production
  AppConfig._prod()
    : environment = Environment.production,
      baseUrl = ApiEndpoints.baseProdUrl,
      apiKey = 'PROD_API_KEY_123',
      // Keycloak specific production settings
      keycloakBaseUrl = ApiEndpoints.keycloakProdUrl,
      keycloakRealm = ApiEndpoints.keycloakProdRealm,
      keycloakClientId = ApiEndpoints.keycloakProdClientId,
      keycloakClientSecret = ApiEndpoints.keycloakProdClientSecret,
      termsOfUseUrl = LegalUrls.prodTermsOfUse,
      privacyPolicyUrl = LegalUrls.prodPrivacyPolicy,
      aboutUsUrl = LegalUrls.prodAboutUs,
      contactUsUrl = LegalUrls.prodContactUs,
      faqUrl = LegalUrls.prodFaq,
      logbookUrl = LegalUrls.prodLogbook;

  // Private constructor for Pre-Production
  AppConfig._preprod()
    : environment = Environment.preprod,
      baseUrl = ApiEndpoints.basePreProdUrl,
      apiKey = 'PREPROD_API_KEY_456',
      // Keycloak specific pre-production settings
      keycloakBaseUrl = ApiEndpoints.keycloakPreProdUrl,
      keycloakRealm = ApiEndpoints.keycloakPreProdRealm,
      keycloakClientId = ApiEndpoints.keycloakPreProdClientId,
      keycloakClientSecret = ApiEndpoints.keycloakPreProdClientSecret,
      termsOfUseUrl = LegalUrls.preprodTermsOfUse,
      privacyPolicyUrl = LegalUrls.preprodPrivacyPolicy,
      aboutUsUrl = LegalUrls.preprodAboutUs,
      contactUsUrl = LegalUrls.preprodContactUs,
      faqUrl = LegalUrls.preprodFaq,
      logbookUrl = LegalUrls.preprodLogbook;

  // Private constructor for Staging (Default)
  AppConfig._staging()
    : environment = Environment.staging,
      baseUrl = ApiEndpoints.baseStagingUrl,
      apiKey = 'STAGING_API_KEY_789',
      // Keycloak specific staging settings
      keycloakBaseUrl = ApiEndpoints
          .keycloakStagingUrl, // e.g., https://stg-keycloak.ocacademy.in
      keycloakRealm = ApiEndpoints.keycloakStagingRealm,
      keycloakClientId = ApiEndpoints.keycloakStagingClientId,
      keycloakClientSecret =
          ApiEndpoints.keycloakStagingClientSecret, // e.g., stg-ocacademy
      termsOfUseUrl = LegalUrls.stagingTermsOfUse,
      privacyPolicyUrl = LegalUrls.stagingPrivacyPolicy,
      aboutUsUrl = LegalUrls.stagingAboutUs,
      contactUsUrl = LegalUrls.stagingContactUs,
      faqUrl = LegalUrls.stagingFaq,
      logbookUrl = LegalUrls.stagingLogbook;
}
