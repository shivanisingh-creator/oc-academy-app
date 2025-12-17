import 'package:flutter/material.dart';
import 'package:oc_academy_app/core/constants/route_constants.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        // User is logged in, navigate to home
        Navigator.pushReplacementNamed(context, RouteConstants.home);
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
