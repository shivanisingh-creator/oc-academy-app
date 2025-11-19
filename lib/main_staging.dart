

import 'package:flutter/material.dart';
import 'package:oc_academy_app/app/app_config.dart';
import 'package:oc_academy_app/app/app.dart'; // Import the new App widget
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the environment for the app entry point
  const environment = 'staging'; 
  final config = AppConfig.forEnvironment(environment);
  ApiUtils.initialize(config); // Initialize ApiUtils

  runApp(App(config: config)); 
}
