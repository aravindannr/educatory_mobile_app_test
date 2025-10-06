import 'package:educatory_mobile_application/core/constants/app_routes.dart';
import 'package:educatory_mobile_application/core/utils/helpers.dart';
import 'package:educatory_mobile_application/core/utils/validators.dart';
import 'package:educatory_mobile_application/providers/login_provider.dart';
import 'package:educatory_mobile_application/services/api_services.dart';
import 'package:educatory_mobile_application/views/widgets/custom_button.dart';
import 'package:educatory_mobile_application/views/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<void> handleGoogleSignIn() async {
    final provider = Provider.of<LoginProvider>(context, listen: false);

    try {
      final userCredential = await provider.signInWithGoogle();

      if (userCredential != null && mounted) {
        final user = userCredential.user;

        final email = user?.email ?? '';

        if (email.isEmpty) {
          Helpers.showSnackBar(
            context,
            "Unable to retrieve email from Google account",
          );
          return;
        }

        final String? emailValidation = Validators.validateEmail(email);

        if (emailValidation != null) {
          Helpers.showSnackBar(context, emailValidation);
          return;
        }

        final otpResponse = await ApiServices().getOtp(email);

        if (otpResponse.message == "OTP sent to email successfully.") {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("userEmail", email);
          await prefs.setString("userFullName", user?.displayName ?? '');

          AppRoutes.navigateTo(
            context,
            AppRoutes.otp,
            arguments: {'email': email, 'isFromSignIn': true},
          );
        } else {
          Helpers.showSnackBar(
            context,
            otpResponse.message ?? "Failed to send OTP",
          );
          Helpers.print(otpResponse.message ?? '');
        }
      } else if (mounted) {
        Helpers.showSnackBar(context, "Google sign-in was cancelled");
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(context, "Error: ${e.toString()}");
        Helpers.print("Google Sign-In Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<LoginProvider>(
          builder: (context, value, child) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  CustomTextfield(
                    fieldHeading: "Email",
                    hintText: "penoftdesign@gmail.com",
                    controller: value.emailController,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Checkbox(
                              value: value.rememberMe,
                              onChanged: (val) {
                                value.rememberClick(val);
                              },
                              activeColor: const Color(0xFF8932EB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Remember me",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   "Forgot Password?",
                      //   style: GoogleFonts.inter(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     color: Colors.deepPurple,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    onPressed: () async {
                      try {
                        final String? emailValidation =
                            Validators.validateEmail(
                              value.emailController.text,
                            );
                        if (emailValidation != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(emailValidation)),
                          );
                        } else {
                          final otpResponse = await ApiServices().getOtp(
                            value.emailController.text,
                          );
                          if (otpResponse.message ==
                              "OTP sent to email successfully.") {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString(
                              "userEmail",
                              value.emailController.text,
                            );
                            AppRoutes.navigateTo(
                              context,
                              AppRoutes.otp,
                              arguments: {
                                'email': value.emailController.text,
                                'isFromSignIn': true,
                              },
                            );
                            value.clearEmail();
                          } else {
                            Helpers.showSnackBar(
                              context,
                              otpResponse.message ?? "",
                            );
                            Helpers.print(otpResponse.message ?? '');
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error sending OTP: $e")),
                        );
                      }
                    },
                    buttonActionText: "Continue",
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.inter(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Register",
                            style: GoogleFonts.inter(
                              color: const Color(0xFF8932EB),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                value.clearEmail();
                                AppRoutes.navigateTo(context, AppRoutes.signUp);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "OR",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/images/google.svg',
                        height: 24,
                        width: 24,
                      ),
                      label: Text(
                        "Continue with Google",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
