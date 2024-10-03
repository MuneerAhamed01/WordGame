import 'package:english_wordle/views/screens/auth/auth_controller.dart';
import 'package:english_wordle/views/widgets/button.dart';
import 'package:english_wordle/views/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthScreen extends GetView<AuthController> {
  static const String routeName = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<AuthController>(
          builder: (_) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                const AnimatedGradientSquares(
                  squareSize: 32,
                ),
                Text(
                  'WordSchool',
                  style: GoogleFonts.crimsonText(
                      fontSize: 54, color: Colors.white),
                ),
                // const Spacer(),
                Text(
                  'Start your day by brainstorming once :)',
                  style: GoogleFonts.crimsonText(
                      fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 48,
                    child: AppButton(
                      onTap: controller.signUpWithGoogle,
                      isLoading: controller.isLoadingGoogle,
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
                      onTap: controller.signUpAnonymosly,
                      isLoading: controller.isLoadingAnonymously,
                      label: 'Sign up anonymosly',
                      type: ButtonType.background,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                _launchUrl('https://sites.google.com/view/wordschool/home');
              },
              child: const Text(
                'By continue you are accepting our privacy policy. Click here to see privacy policy',
                style: TextStyle(
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            
            ),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }
  Future<void> _launchUrl(String url) async {
final myurl = Uri.parse(url);
  if (!await launchUrl(myurl)) {
    throw Exception('Could not launch $myurl');
  }
}
}
