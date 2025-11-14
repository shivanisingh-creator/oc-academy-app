

import 'package:flutter/material.dart';
import 'package:oc_academy_app/app/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the environment for the app entry point
  const environment = 'staging'; 
  final config = AppConfig.forEnvironment(environment);

  // Initialize your application with the specific configuration
  //runApp(MyApp(config: config)); 
}
