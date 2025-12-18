import 'package:flutter/material.dart';
import 'package:oc_academy_app/core/constants/route_constants.dart';
import 'package:oc_academy_app/presentation/features/auth/login_page.dart';
import 'package:oc_academy_app/app/app_config.dart'; // Import AppConfig
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_academy_app/data/repositories/home_repository.dart';
import 'package:oc_academy_app/data/repositories/login_repository.dart';
import 'package:oc_academy_app/data/repositories/user_repository.dart';
import 'package:oc_academy_app/presentation/features/home/view/medical_academy_screen.dart'; // Import MedicalAcademyScreen
import 'package:oc_academy_app/presentation/features/profile/bloc/profile_bloc.dart';
import 'package:oc_academy_app/presentation/features/profile/view/profile_screen.dart';
import 'package:oc_academy_app/presentation/global/screens/splash_screen.dart'; // Import SplashScreen

class App extends StatelessWidget {
  final AppConfig config; // Add AppConfig as a field
  const App({super.key, required this.config}); // Modify constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute:
          '/', // Set initial route to a generic path for splash screen
      routes: {
        '/': (context) =>
            const SplashScreen(), // Map generic path to SplashScreen
        RouteConstants.login: (context) => LoginPage(config: config),
        RouteConstants.home: (context) => const MedicalAcademyScreen(),
        RouteConstants.profile: (context) => BlocProvider(
          create: (context) => ProfileBloc(
            homeRepository: HomeRepository(),
            authRepository: AuthRepository(),
            userRepository: UserRepository(),
          )..add(FetchProfileData()),
          child: const ProfileScreen(),
        ),
      },
    );
  }
}
