import 'package:educatory_mobile_application/views/bottom_nav_bar.dart';
import 'package:educatory_mobile_application/views/screens/auth/full_name_screen.dart';
import 'package:educatory_mobile_application/views/screens/auth/login_screen.dart';
import 'package:educatory_mobile_application/views/screens/auth/otp_screen.dart';
import 'package:educatory_mobile_application/views/screens/auth/profile_success_screen.dart';
import 'package:educatory_mobile_application/views/screens/auth/profile_update_screen.dart';
import 'package:educatory_mobile_application/views/screens/auth/sign_up_screen.dart';
import 'package:educatory_mobile_application/views/screens/onboarding/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String otp = '/otp';
  static const String fullName = '/full-name';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String profileSuccess = '/profile-success';
  static const String profileUpdate = '/profile-update';
  static const String courseDetail = '/course-detail';
  static const String myCourses = '/my-courses';

  // Route Generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case signIn:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case otp:
        final args = settings.arguments as Map<String, dynamic>?;
        final isFromSignIn = args?['isFromSignIn'] as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            email: args?['email'] ?? '',
            isFromSignIn: isFromSignIn,
          ),
        );

      case fullName:
        return MaterialPageRoute(builder: (_) => const FullNameScreen());

      case home:
        return MaterialPageRoute(builder: (_) => const BottomNavBar());

      case profileSuccess:
        return MaterialPageRoute(builder: (_) => const ProfileSuccessScreen());

      case profileUpdate:
        final args = settings.arguments as Map<String, dynamic>?;
        final isFromSignIn = args?['isFromSignIn'] as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => ProfileUpdateScreen(isFromSignIn: isFromSignIn),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  // Navigation Helper Methods
  static Future<dynamic> navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static Future<dynamic> navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> navigateAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }
}
