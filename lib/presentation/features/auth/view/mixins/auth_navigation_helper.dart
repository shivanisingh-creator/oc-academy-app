import 'package:flutter/material.dart';
import 'package:oc_academy_app/core/utils/storage.dart';
import 'package:oc_academy_app/presentation/features/auth/view/signup_screen.dart';
import 'package:oc_academy_app/presentation/features/auth/view/widgets/home_page_screen.dart';
import 'package:oc_academy_app/data/repositories/user_repository.dart';

class AuthNavigationHelper {
  static Future<void> handleLoginSuccess({
    required BuildContext context,
    required bool isNewUser,
    String? accessToken,
    String? preAccessToken,
    required String phoneNumber,
    String? email,
  }) async {
    final TokenStorage tokenStorage = TokenStorage();

    if (isNewUser) {
      if (preAccessToken != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignupScreen(
              phoneNumber: email != null && email.isNotEmpty ? "" : phoneNumber,
              preAccessToken: preAccessToken,
              email: email,
            ),
          ),
        );
      }
    } else {
      if (accessToken != null) {
        await tokenStorage.saveApiAccessToken(accessToken);

        // Fetch user details
        final UserRepository userRepository = UserRepository();
        await userRepository.getUserLite();

        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      }
    }
  }
}
