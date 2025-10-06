import 'package:educatory_mobile_application/core/constants/app_routes.dart';
import 'package:educatory_mobile_application/core/utils/helpers.dart';
import 'package:educatory_mobile_application/services/api_services.dart';
import 'package:educatory_mobile_application/views/widgets/custom_button.dart';
import 'package:educatory_mobile_application/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullNameScreen extends StatefulWidget {
  const FullNameScreen({super.key});

  @override
  State<FullNameScreen> createState() => _FullNameScreenState();
}

class _FullNameScreenState extends State<FullNameScreen> {
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
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
                "What’s your name?",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              CustomTextfield(
                fieldHeading: "Full Name",
                hintText: "Name",
                controller: nameController,
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: () async {
                  final fullName = nameController.text.trim();
                  if (fullName.isEmpty) {
                    Helpers.showSnackBar(context, "Please enter your name");
                  } else {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    String? token = preferences.getString("token");
                    preferences.setString("fullName", fullName);
                    final response = await ApiServices().addFullName(
                      fullName,
                      token,
                    );
                    if (response.message != "Fullname added successfully.") {
                      Helpers.showSnackBar(
                        context,
                        "Failed to update Full name",
                      );
                    } else {
                      AppRoutes.navigateTo(
                        arguments: {'isFromSignIn': true},
                        context,
                        AppRoutes.profileUpdate,
                      );
                    }
                  }
                },
                buttonActionText: "Continue",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
