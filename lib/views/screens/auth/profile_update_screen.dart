import 'package:educatory_mobile_application/core/constants/app_routes.dart';
import 'package:educatory_mobile_application/core/utils/helpers.dart';
import 'package:educatory_mobile_application/providers/profile_provider.dart';
import 'package:educatory_mobile_application/services/api_services.dart';
import 'package:educatory_mobile_application/views/widgets/custom_button.dart';
import 'package:educatory_mobile_application/views/widgets/custom_dropdown_field.dart';
import 'package:educatory_mobile_application/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key, required this.isFromSignIn});
  final bool isFromSignIn;

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  TextEditingController fullNameController = TextEditingController();
  String? userEmail;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString("fullName");
    String? savedEmail = prefs.getString("userEmail");
    int? savedPhone = prefs.getInt("userPhoneNumber");

    setState(() {
      if (savedName != null && savedName.isNotEmpty) {
        fullNameController.text = savedName;
      }
      userEmail = savedEmail ?? "No email found";
      phoneNumber = savedPhone?.toString() ?? "No number found";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                "Your Profile",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "If needed you can change the details by clicking \non them",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Profile Picture",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 15),
              Consumer<ProfileProvider>(
                builder: (context, provider, _) {
                  return GestureDetector(
                    onTap: () => provider.pickAndUploadImage(context),
                    child: provider.isUploading
                        ? const Center(child: CircularProgressIndicator())
                        : provider.selectedImage != null
                        ? CircleAvatar(
                            radius: 55,
                            backgroundImage: FileImage(provider.selectedImage!),
                          )
                        : SvgPicture.asset("assets/images/image_upload.svg"),
                  );
                },
              ),
              SizedBox(height: 10),
              CustomTextfield(
                fieldHeading: "Full Name",
                hintText: "hintText",
                controller: fullNameController,
              ),
              SizedBox(height: 10),
              CustomDropdownField(
                fieldHeading: "Mail Id",
                hintText: userEmail ?? "Loading...",
                items: [if (userEmail != null) userEmail!],
                onChanged: (value) {},
              ),
              SizedBox(height: 20),
              if (widget.isFromSignIn)
                CustomDropdownField(
                  fieldHeading: "Phone Number",
                  hintText: "hintText",
                  items: ["+919066110000"],
                  onChanged: (value) {},
                ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final fullName = prefs.getString("userFullName") ?? '';
                  final fullNameFromFullNamePage =
                      prefs.getString("fullName") ?? '';
                  final email = prefs.getString("userEmail") ?? '';
                  final phoneNumber = prefs.getString("userPhoneNumber") ?? '';
                  final imageUrl = prefs.getString("userImageUrl") ?? '';
                  try {
                    final response = await ApiServices().createUser(
                      widget.isFromSignIn ? fullName : fullNameFromFullNamePage,
                      email,
                      phoneNumber,
                      imageUrl,
                    );
                    if (response.email != null) {
                      AppRoutes.navigateTo(context, AppRoutes.profileSuccess);
                    } else {
                      Helpers.showSnackBar(
                        context,
                        response.message ?? "Failed to create user",
                      );
                    }
                  } catch (e) {
                    Helpers.showSnackBar(context, "Error: $e");
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
