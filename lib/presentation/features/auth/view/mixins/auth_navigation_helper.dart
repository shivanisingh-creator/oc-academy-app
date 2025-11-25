import 'package:flutter/material.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:oc_academy_app/presentation/features/auth/view/signup_screen.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/home_page_screen.dart';

class AuthNavigationHelper {
  static Future<void> handleLoginSuccess({
    required BuildContext context,
    required bool isNewUser,
    String? accessToken,
    String? preAccessToken,
    required String phoneNumber,
  }) async {
    final TokenStorage tokenStorage = TokenStorage();

    if (isNewUser) {
      if (preAccessToken != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignupScreen(
              phoneNumber: phoneNumber,
              preAccessToken: preAccessToken,
            ),
          ),
        );
      }
    } else {
      if (accessToken != null) {
        await tokenStorage.saveApiAccessToken(accessToken);
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      }
    }
  }
}
