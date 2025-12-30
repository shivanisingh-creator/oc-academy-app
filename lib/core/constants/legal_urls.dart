import 'package:oc_academy_app/app/app_config.dart';

class LegalUrls {
  static const String preprodTermsOfUse =
      'https://preprod.ocacademy.in/mob-app/terms-of-use';
  static const String prodTermsOfUse =
      'https://ocacademy.in/mob-app/terms-of-use';
  static const String stagingTermsOfUse =
      'https://stg.ocacademy.in/mob-app/terms-of-use';

  static const String preprodPrivacyPolicy =
      'https://preprod.ocacademy.in/mob-app/privacy-policy';
  static const String prodPrivacyPolicy =
      'https://ocacademy.in/mob-app/privacy-policy';
  static const String stagingPrivacyPolicy =
      'https://stg.ocacademy.in/mob-app/privacy-policy';

  static const String preprodAboutUs =
      'https://preprod.ocacademy.in/mob-app/about-us';
  static const String prodAboutUs = 'https://ocacademy.in/mob-app/about-us';
  static const String stagingAboutUs =
      'https://stg.ocacademy.in/mob-app/about-us';

  static const String preprodContactUs =
      'https://preprod.ocacademy.in/mob-app/contact-us';
  static const String prodContactUs = 'https://ocacademy.in/mob-app/contact-us';
  static const String stagingContactUs =
      'https://stg.ocacademy.in/mob-app/contact-us';

  static const String preprodFaq = 'https://preprod.ocacademy.in/mob-app/faq';
  static const String prodFaq = 'https://ocacademy.in/mob-app/faq';
  static const String stagingFaq = 'https://stg.ocacademy.in/mob-app/faq';

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

  static String getAboutUsUrl(Environment env) {
    switch (env) {
      case Environment.production:
        return prodAboutUs;
      case Environment.preprod:
        return preprodAboutUs;
      case Environment.staging:
        return stagingAboutUs;
    }
  }

  static String getContactUsUrl(Environment env) {
    switch (env) {
      case Environment.production:
        return prodContactUs;
      case Environment.preprod:
        return preprodContactUs;
      case Environment.staging:
        return stagingContactUs;
    }
  }

  static String getFaqUrl(Environment env) {
    switch (env) {
      case Environment.production:
        return prodFaq;
      case Environment.preprod:
        return preprodFaq;
      case Environment.staging:
        return stagingFaq;
    }
  }
}
