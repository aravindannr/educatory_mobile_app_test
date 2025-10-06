import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Helpers {
  /// SnackBar
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }

  ///print
  static void print(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
