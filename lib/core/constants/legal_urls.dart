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

  static const String categoryPrefix = 'mob-app/courses-by-category/';
  static const String certifications = 'certifications';
  static const String fellowships = 'fellowships';
  static const String postGrad = 'post-graduate-programs';
  static const String pgDip = 'pg-dip';
  static const String msc = 'msc';
  static const String fellowshipsAndPostGrad =
      'fellowship-and-post-graduate-programs';
  static const String internationalDiplomaAndMsc =
      'international-diploma-and-msc';

  static const String specialityPrefix = 'mob-app/courses-by-speciality/';

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

  static const String preprodLogbook =
      'https://preprod-logbook.ocacademy.in/login';
  static const String prodLogbook = 'https://logbook.ocacademy.in/login';
  static const String stagingLogbook = 'https://stg-logbook.ocacademy.in/login';

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

  static String getLogbookUrl(Environment env) {
    switch (env) {
      case Environment.production:
        return prodLogbook;
      case Environment.preprod:
        return preprodLogbook;
      case Environment.staging:
        return stagingLogbook;
    }
  }

  static String getCategoryUrl(Environment env, String category) {
    final String baseUrl;
    switch (env) {
      case Environment.production:
        baseUrl = 'https://ocacademy.in/';
        break;
      case Environment.preprod:
        baseUrl = 'https://preprod.ocacademy.in/';
        break;
      case Environment.staging:
        baseUrl = 'https://stg.ocacademy.in/';
        break;
    }

    String path;
    switch (category.toLowerCase()) {
      case 'certifications':
      case 'certification programs':
        path = certifications;
        break;
      case 'fellowships':
      case 'fellowship programs':
        path = fellowships;
        break;
      case 'post-graduate-programs':
      case 'post graduate programs':
      case 'international post graduate programs':
      case 'international pg programs':
      case 'post graduate program':
      case 'post grad program':
      case 'pg programs':
      case 'pg program':
        path = postGrad;
        break;
      case 'pg-dip':
      case 'diploma':
        path = pgDip;
        break;
      case 'msc':
      case 'msc program':
        path = msc;
        break;
      case 'fellowship-and-post-graduate-programs':
      case 'fellowship and post graduate programs':
        path = fellowshipsAndPostGrad;
        break;
      case 'international-diploma-and-msc':
      case 'international diploma and msc':
        path = internationalDiplomaAndMsc;
        break;
      default:
        path = '';
    }

    return '$baseUrl$categoryPrefix$path';
  }

  static String getSpecialityUrl(Environment env, String specialityName) {
    final String baseUrl;
    switch (env) {
      case Environment.production:
        baseUrl = 'https://ocacademy.in/';
        break;
      case Environment.preprod:
        baseUrl = 'https://preprod.ocacademy.in/';
        break;
      case Environment.staging:
        baseUrl = 'https://stg.ocacademy.in/';
        break;
    }

    // Replace spaces with hyphens and make it lowercase for the URL
    final String formattedName = specialityName.toLowerCase().replaceAll(
      ' ',
      '-',
    );

    return '$baseUrl$specialityPrefix$formattedName';
  }
}
