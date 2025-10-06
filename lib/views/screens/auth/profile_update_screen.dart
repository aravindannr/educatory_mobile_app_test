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

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userAvatar = '';

  Future<void> _fetchProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No token found');

      final response = await ApiServices().fetchProfile(token: token);

      setState(() {
        userName = response.user?.fullname ?? 'Unknown';
        userEmail = response.user?.email ?? 'No email';
        userPhone = response.user?.phone?.toString() ?? 'No phone';
        userAvatar =
            response.user?.picture ??
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&size=200&background=7C3AED&color=fff';
        fullNameController.text = userName;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      }
    }
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
                readOnly: widget.isFromSignIn,
                fieldHeading: "Full Name",
                hintText: "FullName",
                controller: fullNameController,
              ),
              SizedBox(height: 10),
              CustomDropdownField(
                fieldHeading: "Mail Id",
                hintText: userEmail,
                items: [userEmail],
                value: userEmail,
                onChanged: (value) {},
              ),
              SizedBox(height: 20),
              if (widget.isFromSignIn)
                CustomDropdownField(
                  fieldHeading: "Phone Number",
                  hintText: userPhone,
                  items: [userPhone],
                  value: userPhone,
                  onChanged: (value) {},
                ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  final profileProvider = Provider.of<ProfileProvider>(
                    context,
                    listen: false,
                  );

                  final imageUrl =
                      profileProvider.uploadedImageUrl?.isNotEmpty == true
                      ? profileProvider.uploadedImageUrl!
                      : userAvatar;

                  try {
                    final response = await ApiServices().createUser(
                      userName,
                      userEmail,
                      userPhone,
                      imageUrl,
                    );
                    final message = response.message ?? response.error ?? '';

                    if (message.toLowerCase().contains(
                          "user created successfully",
                        ) ||
                        message.toLowerCase().contains("user already exists")) {
                      AppRoutes.navigateTo(context, AppRoutes.profileSuccess);
                    } else {
                      Helpers.showSnackBar(context, message);
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
