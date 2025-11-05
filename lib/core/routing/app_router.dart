import 'package:go_router/go_router.dart';
import 'package:oc_academy_app/presentation/features/auth/view/login_screen.dart';
import 'package:oc_academy_app/presentation/features/home/view/home_screen.dart';
import 'package:oc_academy_app/core/constants/route_constants.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
