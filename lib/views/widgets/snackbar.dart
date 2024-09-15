import 'package:flutter/material.dart';

class SnackBarService {
  static final SnackBarService _instance = SnackBarService._internal();
  factory SnackBarService() => _instance;
  SnackBarService._internal();

  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    if (messengerKey.currentState != null) {
      messengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          duration: duration,
          backgroundColor: backgroundColor,
        ),
      );
    }
  }
}
