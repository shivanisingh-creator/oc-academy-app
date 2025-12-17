import 'package:flutter/material.dart';
import 'package:oc_academy_app/app/app_config.dart';
import 'package:oc_academy_app/app/app.dart'; // Import the new App widget
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:oc_academy_app/core/utils/storage.dart'; // Import TokenStorage
import 'package:logger/logger.dart'; // Import Logger
import 'package:oc_academy_app/domain/entities/keycloak_service.dart'; // Import KeycloakService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final TokenStorage tokenStorage = TokenStorage(); // Instantiate TokenStorage
  final Logger logger = Logger(); // Instantiate Logger
  final KeycloakService keycloakService = KeycloakService(
    config: AppConfig.forEnvironment('preprod'),
    tokenStorage: tokenStorage,
  ); // Instantiate KeycloakService

  // Set the environment for the app entry point
  const environment = 'preprod'; // Changed from 'staging' to 'preprod'
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
