import 'package:educatory_mobile_application/core/constants/app_routes.dart';
import 'package:educatory_mobile_application/core/utils/helpers.dart';
import 'package:educatory_mobile_application/providers/otp_page_provider.dart';
import 'package:educatory_mobile_application/services/api_services.dart';
import 'package:educatory_mobile_application/views/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final bool isFromSignIn;

  const OtpScreen({super.key, required this.email, required this.isFromSignIn});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<OtpPageProvider>(
          builder: (context, value, child) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: Colors.black87,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Back",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Enter verification code",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Enter the verification code send to",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    widget.email,
                    style: GoogleFonts.inter(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        height: 48,
                        width: 48,
                        margin: EdgeInsets.only(left: index == 0 ? 0 : 10),
                        padding: const EdgeInsets.only(bottom: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          border: Border.all(
                            color: value.focusNodes[index].hasFocus
                                ? Colors.deepPurple
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: KeyboardListener(
                          focusNode: FocusNode(),
                          onKeyEvent: (event) {
                            if (event is KeyDownEvent &&
                                event.logicalKey ==
                                    LogicalKeyboardKey.backspace) {
                              if (value.otpControllers[index].text.isEmpty &&
                                  index > 0) {
                                value.focusNodes[index - 1].requestFocus();
                              }
                            }
                          },
                          child: TextField(
                            controller: value.otpControllers[index],
                            focusNode: value.focusNodes[index],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            autofocus: index == 0,
                            style: GoogleFonts.poppins(
                              // color: headlineText,
                              // fontSize: otpFontSize,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            // cursorHeight: otpFontSize * 1.2,
                            // cursorColor: headlineText,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                            onChanged: (val) {
                              value.updateOtpBtn();

                              if (val.isNotEmpty && index < 5) {
                                value.focusNodes[index + 1].requestFocus();
                              }

                              // if last box and all filled → unfocus
                              if (index == 5) {
                                bool allFilled = value.otpControllers.every(
                                  (controller) =>
                                      controller.text.trim().isNotEmpty,
                                );
                                if (allFilled) {
                                  FocusScope.of(context).unfocus();
                                }
                              }
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 15),
                  CustomButton(
                    onPressed: () async {
                      try {
                        String otp = value.otpControllers
                            .map((controller) => controller.text)
                            .join();

                        final response = await ApiServices().verifyOtp(
                          widget.email,
                          otp,
                        );

                        if (response.message == "OTP verified successfully.") {
                          final prefs = await SharedPreferences.getInstance();
                          if (response.token != null) {
                            prefs.setString("token", response.token!);
                          }
                          if (response.userId != null) {
                            prefs.setInt("userId", response.userId!);
                          }

                          widget.isFromSignIn
                              ? AppRoutes.navigateTo(
                                  context,
                                  AppRoutes.profileUpdate,
                                  arguments: {'isFromSignIn': true},
                                )
                              : AppRoutes.navigateTo(
                                  context,
                                  AppRoutes.fullName,
                                );

                          value.clearOtp();
                        } else {
                          Helpers.showSnackBar(context, response.message ?? '');
                        }
                      } catch (e) {
                        String errorMsg = e.toString();
                        if (errorMsg.contains("{\"error\":")) {
                          final start = errorMsg.indexOf("{\"error\":");
                          errorMsg = errorMsg.substring(start);
                          errorMsg = errorMsg
                              .replaceAll(RegExp(r'[\{\}"error:]'), '')
                              .trim();
                        }
                        Helpers.showSnackBar(context, errorMsg);
                      }
                    },

                    buttonActionText: "Continue",
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Didnt recieved the code? ",
                        style: GoogleFonts.inter(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Resend",
                            style: GoogleFonts.inter(
                              color: Color(0xFF8932EB),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                value.resendOtp(widget.email);
                              },
                          ),
                          TextSpan(
                            text: " in ${value.resendTimer} second",
                            style: GoogleFonts.inter(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
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
