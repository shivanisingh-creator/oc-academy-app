import 'package:flutter/material.dart';
import 'package:oc_academy_app/core/constants/route_constants.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oc_academy_app/data/repositories/user_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final tokenStorage = TokenStorage();
    final accessToken = await tokenStorage.getApiAccessToken();

    if (mounted) {
      if (accessToken != null) {
        // Verify the token by fetching user profile
        try {
          final userRepository = UserRepository();
          final userLite = await userRepository.getUserLite();

          if (userLite != null && mounted) {
            // Token is valid
            Navigator.pushReplacementNamed(context, RouteConstants.home);
            return;
          }
        } catch (e) {
          debugPrint("Token validation failed: $e");
        }

        // If we reach here, token is invalid or API failed
        await tokenStorage.deleteApiAccessToken(); // Clear invalid token
        if (mounted) {
          Navigator.pushReplacementNamed(context, RouteConstants.login);
        }
      } else {
        // User is not logged in, navigate to login
        Navigator.pushReplacementNamed(context, RouteConstants.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          "assets/images/oc_academy.svg",
          width: 200, // Adjust size as needed
        ),
      ),
    );
  }
}
