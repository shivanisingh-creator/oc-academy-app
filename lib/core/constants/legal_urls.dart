import 'package:oc_academy_app/app/app_config.dart';

class LegalUrls {
  static const String preprodTermsOfUse =
      'https://preprod.ocacademy.in/terms-of-use';
  static const String prodTermsOfUse = 'https://ocacademy.in/terms-of-use';
  static const String stagingTermsOfUse =
      'https://stg.ocacademy.in/terms-of-use';

  static const String preprodPrivacyPolicy =
      'https://preprod.ocacademy.in/privacy-policy';
  static const String prodPrivacyPolicy = 'https://ocacademy.in/privacy-policy';
  static const String stagingPrivacyPolicy =
      'https://stg.ocacademy.in/privacy-policy';

  static String getTermsOfUseUrl(Environment env) {
    switch (env) {
      case Environment.production:
        return prodTermsOfUse;
      case Environment.preprod:
        return preprodTermsOfUse;
      case Environment.staging:
        return stagingTermsOfUse;
    }
  }

  static String getPrivacyPolicyUrl(Environment env) {
    switch (env) {
      case Environment.production:
        return prodPrivacyPolicy;
      case Environment.preprod:
        return preprodPrivacyPolicy;
      case Environment.staging:
        return stagingPrivacyPolicy;
    }
  }
}
