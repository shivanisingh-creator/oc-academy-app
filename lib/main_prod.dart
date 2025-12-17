import 'package:flutter/material.dart';
import 'package:oc_academy_app/app/app_config.dart';
import 'package:oc_academy_app/app/app.dart'; // Import the new App widget
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/storage.dart'; // Import TokenStorage
import 'package:logger/logger.dart';
import 'package:oc_academy_app/domain/entities/keycloak_service.dart'; // Import Logger

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final TokenStorage tokenStorage = TokenStorage(); // Instantiate TokenStorage
  final Logger logger = Logger();
  final KeycloakService keycloakService = KeycloakService(
    config: AppConfig.forEnvironment('prod'),
    tokenStorage: tokenStorage,
  ); // Instantiate KeycloakService
  // Instantiate Logger

  // Set the environment for the app entry point
  const environment = 'prod'; // Changed from 'staging' to 'prod'
  final config = AppConfig.forEnvironment(environment);
  ApiUtils.initialize(
    config,
    tokenStorage,
    logger,
    keycloakService,
  ); // Initialize ApiUtils with dependencies

  // Initialize your application with the specific configuration
  runApp(App(config: config));
}
