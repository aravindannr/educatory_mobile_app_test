import 'package:educatory_mobile_application/core/constants/app_routes.dart';
import 'package:educatory_mobile_application/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSuccessScreen extends StatefulWidget {
  const ProfileSuccessScreen({super.key});

  @override
  State<ProfileSuccessScreen> createState() => _ProfileSuccessScreenState();
}

class _ProfileSuccessScreenState extends State<ProfileSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Lottie.asset('assets/images/Confetti.json', repeat: true),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    SvgPicture.asset("assets/images/success_mark.svg"),
                    const SizedBox(height: 40),
                    Text(
                      'Congrats!',
                      style: GoogleFonts.interTight(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You have signed up successfully. Go to home & start exploring courses',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        fontSize: 14,
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 100),
                    CustomButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool("isLogged", true);
                        AppRoutes.navigateTo(context, AppRoutes.home);
                      },
                      buttonActionText: "Go To Home",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
