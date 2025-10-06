import 'package:educatory_mobile_application/core/constants/app_routes.dart';
import 'package:educatory_mobile_application/core/utils/helpers.dart';
import 'package:educatory_mobile_application/core/utils/validators.dart';
import 'package:educatory_mobile_application/providers/sign_up_provider.dart';
import 'package:educatory_mobile_application/services/api_services.dart';
import 'package:educatory_mobile_application/views/widgets/custom_button.dart';
import 'package:educatory_mobile_application/views/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Future<void> handleGoogleSignIn() async {
    final provider = Provider.of<SignUpProvider>(context, listen: false);

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

          AppRoutes.navigateTo(
            context,
            AppRoutes.otp,
            arguments: {'email': email},
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
      body: Consumer<SignUpProvider>(
        builder: (context, value, child) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  //   borderRadius: BorderRadius.circular(8),
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 8),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         const Icon(
                  //           Icons.arrow_back_ios,
                  //           size: 20,
                  //           color: Colors.black87,
                  //         ),
                  //         const SizedBox(width: 5),
                  //         Text(
                  //           "Back",
                  //           style: GoogleFonts.inter(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //             color: Colors.black87,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 40),
                  Text(
                    "Enter your email",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Enter your email to recieve verification code",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF475569),
                    ),
                  ),
                  SizedBox(height: 20),
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
                              arguments: {'email': value.emailController.text},
                            );
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
                  const SizedBox(height: 16),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: GoogleFonts.inter(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: GoogleFonts.inter(
                              color: Color(0xFF8932EB),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                AppRoutes.navigateTo(context, AppRoutes.signIn);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider()),
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
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => handleGoogleSignIn(),
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
            ),
          );
        },
      ),
    );
  }
}
