import 'package:flutter/material.dart';
import 'package:oc_academy_app/core/constants/route_constants.dart';
import 'package:oc_academy_app/presentation/features/auth/login_page.dart';
import 'package:oc_academy_app/app/app_config.dart'; // Import AppConfig

class App extends StatelessWidget {
  final AppConfig config; // Add AppConfig as a field
  const App({super.key, required this.config}); // Modify constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouteConstants.login,
      routes: {
        RouteConstants.login: (context) => LoginPage(config: config),
      },
    );
  }
}