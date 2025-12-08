import 'package:flutter/material.dart';

class SnackBarUtil {
  static void show(
      BuildContext context,
      String message, {
        Color backgroundColor = Colors.redAccent,
        Duration duration = const Duration(seconds: 3),
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
      ),
    );
  }

  /// SnackBar chuyên cho success
  static void success(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.green);
  }

  /// SnackBar chuyên cho warning
  static void warning(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.orangeAccent);
  }

  /// SnackBar chuyên cho error
  static void error(BuildContext context, String message) {
    show(context, message, backgroundColor: Colors.redAccent);
  }
}
