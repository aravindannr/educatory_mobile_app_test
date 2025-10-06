import 'package:educatory_mobile_application/core/utils/helpers.dart';
import 'package:educatory_mobile_application/services/google_sign_in_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final GoogleSignInService googleSignInService = GoogleSignInService();
  bool isGoogleSignInLoading = false;

  Future<UserCredential?> signInWithGoogle() async {
    isGoogleSignInLoading = true;
    notifyListeners();

    try {
      final userCredential = await googleSignInService.signInWithGoogle();
      return userCredential;
    } catch (e) {
      Helpers.print('Error during Google Sign-In: $e');
      return null;
    } finally {
      isGoogleSignInLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
