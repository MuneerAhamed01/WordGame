import 'package:english_wordle/views/utils/colors.dart';
import 'package:flutter/material.dart';

class MyColorScheme extends ColorScheme {
  const MyColorScheme({
    required super.brightness,
    required super.primary,
    required super.onPrimary,
    required super.secondary,
    required super.onSecondary,
    required super.error,
    required super.onError,
    required Color background,
    required Color onBackground,
    required super.surface,
    required super.onSurface,
  });

  factory MyColorScheme.light() {
    return const MyColorScheme(
      brightness: Brightness.light,
      primary: MyColors.green2,
      onPrimary: MyColors.white,
      secondary: MyColors.yellow2,
      onSecondary: MyColors.black,
      error: Colors.red,
      onError: MyColors.white,
      background: MyColors.lightGray,
      onBackground: MyColors.black,
      surface: MyColors.white,
      onSurface: MyColors.black,
    );
  }

  factory MyColorScheme.dark() {
    return const MyColorScheme(
      brightness: Brightness.dark,
      primary: MyColors.green3,
      onPrimary: MyColors.white,
      secondary: MyColors.yellow3,
      onSecondary: MyColors.white,
      error: Colors.red,
      onError: MyColors.white,
      background: MyColors.gray4,
      onBackground: MyColors.white,
      surface: MyColors.gray4,
      onSurface: MyColors.white,
    );
  }
}

class MyTheme {
  static ThemeData lightTheme() {
    final colorScheme = MyColorScheme.light();
    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: MyColors.gray3,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: MyColors.black),
        bodyMedium: TextStyle(color: MyColors.black),
      ),
      // Add more theme configurations as needed
    );
  }

  static ThemeData darkTheme() {
    final colorScheme = MyColorScheme.dark();
    return ThemeData(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: MyColors.white),
        bodyMedium: TextStyle(color: MyColors.white),
      ),
      // Add more theme configurations as needed
    );
  }
}
