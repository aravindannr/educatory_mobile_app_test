import 'dart:io';
import 'package:educatory_mobile_application/core/utils/helpers.dart';
import 'package:educatory_mobile_application/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  File? selectedImage;
  bool isUploading = false;
  String? uploadedImageUrl;

  Future<void> pickAndUploadImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked == null) return;

      selectedImage = File(picked.path);
      notifyListeners();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token != null && selectedImage != null) {
        isUploading = true;
        notifyListeners();

        final imageResponse = await ApiServices().uploadProfilePicture(
          token: token,
          imageFile: selectedImage!,
        );
        final imageUrl = imageResponse?.picture ?? '';
        uploadedImageUrl = imageUrl;
        await prefs.setString("userImageUrl", imageUrl);

        Helpers.print("Profile image uploaded successfully: $imageUrl");

        isUploading = false;
        notifyListeners();
      } else {
        Helpers.print("Token or image is null");
      }
    } catch (e) {
      isUploading = false;
      notifyListeners();
      Helpers.print("Image picking failed: $e");
    }
  }
}
