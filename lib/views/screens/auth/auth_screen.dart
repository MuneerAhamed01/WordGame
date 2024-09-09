import 'package:english_wordle/views/screens/auth/auth_controller.dart';
import 'package:english_wordle/views/widgets/button.dart';
import 'package:english_wordle/views/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends GetView<AuthController> {
  static const String routeName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            const AnimatedGradientSquares(
              squareSize: 32,
            ),
            Text(
              'WordSchool',
              style: GoogleFonts.crimsonText(fontSize: 54, color: Colors.white),
            ),
            // const Spacer(),
            Text(
              'Start your day by brainstorming once :)',
              style: GoogleFonts.crimsonText(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 48,
                child: AppButton(
                  onTap: () {},
                  label: 'Continue with google',
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 48,
                child: AppButton(
                  onTap: () {},
                  label: 'Sign up anonymosly',
                  type: ButtonType.background,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
