

import 'package:flutter/material.dart';
import 'package:oc_academy_app/app/app_config.dart';
import 'package:oc_academy_app/app/app.dart'; // Import the new App widget
import 'package:oc_academy_app/core/utils/helpers/api_utils.dart';
import 'package:firebase_core/firebase_core.dart'; // Import firebase_core

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the environment for the app entry point
  const environment = 'preprod'; // Changed from 'staging' to 'preprod'
  final config = AppConfig.forEnvironment(environment);
  ApiUtils.initialize(config); // Initialize ApiUtils

  // Initialize your application with the specific configuration
  runApp(App(config: config)); 
}