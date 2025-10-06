import 'package:educatory_mobile_application/services/google_sign_in_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/utils/helpers.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final GoogleSignInService googleSignInService = GoogleSignInService();
  bool isGoogleSignInLoading = false;

  bool rememberMe = false;
  void rememberClick(bool? val) {
    rememberMe = val ?? !rememberMe;
    notifyListeners();
  }

  void clearEmail() {
    if (emailController.text.isNotEmpty) {
      emailController.clear();
      notifyListeners();
    }
  }

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
}
