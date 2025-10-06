import 'package:educatory_mobile_application/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogged = prefs.getBool('isLogged');

    await Future.delayed(const Duration(seconds: 3));

    if (isLogged == true) {
      AppRoutes.navigateAndReplace(context, AppRoutes.home);
    } else {
      AppRoutes.navigateAndReplace(context, AppRoutes.signUp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/splash_image.png",
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 20),
            Text(
              "educatory",
              style: GoogleFonts.interTight(
                fontWeight: FontWeight.w700,
                fontSize: 52,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
