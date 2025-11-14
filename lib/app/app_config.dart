// lib/config/app_config.dart

enum Environment { production, preprod, staging }

class AppConfig {
  final Environment environment;
  final String baseUrl;
  final String apiKey;
  // Add other environment-specific settings here

  AppConfig({
    required this.environment,
    required this.baseUrl,
    required this.apiKey,
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

  // Private constructor for Production
  AppConfig._prod()
      : environment = Environment.production,
        baseUrl = 'https://api.yourproduct.com/v1', // ⚠️ Actual Production URL
        apiKey = 'PROD_API_KEY_123';

  // Private constructor for Pre-Production
  AppConfig._preprod()
      : environment = Environment.preprod,
        baseUrl = 'https://api.yourpreprod.com/v1', // Pre-Production URL
        apiKey = 'PREPROD_API_KEY_456';

  // Private constructor for Staging (Default)
  AppConfig._staging()
      : environment = Environment.staging,
        baseUrl = 'https://api.yourstaging.com/v1', // Staging/Dev URL
        apiKey = 'STAGING_API_KEY_789';
}