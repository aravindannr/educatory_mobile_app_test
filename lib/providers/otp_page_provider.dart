import 'dart:async';
import 'package:educatory_mobile_application/core/utils/helpers.dart';
import 'package:educatory_mobile_application/services/api_services.dart';
import 'package:flutter/material.dart';

class OtpPageProvider extends ChangeNotifier {
  List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  bool isOtpComplete = false;
  int resendTimer = 60;
  Timer? _timer;
  bool canResend = false;
  bool isResending = false;

  OtpPageProvider() {
    startTimer();
  }

  void updateOtpBtn() {
    isOtpComplete = otpControllers.every(
      (controller) => controller.text.trim().isNotEmpty,
    );
    notifyListeners();
  }

  void startTimer() {
    canResend = false;
    resendTimer = 60;
    isResending = false;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer > 0) {
        resendTimer--;
        notifyListeners();
      } else {
        canResend = true;
        _timer?.cancel();
        notifyListeners();
      }
    });
  }

  Future<void> resendOtp(String email) async {
    if (!canResend || isResending) return;

    isResending = true;
    notifyListeners();

    try {
      ApiServices().getOtp(email);
      startTimer();
    } catch (e) {
      Helpers.print("Error while resending OTP: $e");
      isResending = false;
    }
  }

  void clearOtp() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    isOtpComplete = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
