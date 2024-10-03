import 'package:english_wordle/services/auth/auth_service.dart';
import 'package:english_wordle/views/screens/auth/auth_screen.dart';
import 'package:english_wordle/views/widgets/slidedown_dalog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              // Handle logout action
              showSlidingDialog(
                title: "Are you sure you want to logout your account?",
                onPressContinue: () async {
                  await Get.find<AuthService>().signOut();
                  Get.offAllNamed(AuthScreen.routeName);
                },
              );
              // _showConfirmationDialog(context, 'Logout');
            },
          ),
          ListTile(
            title: const Text('Delete Account'),
            onTap: () {
              // Handle delete account action
              // _showConfirmationDialog(context, 'Delete Account');
              showSlidingDialog(
                title: "Are you sure you want to delete your account?",
                onPressContinue: () {
                  Get.find<AuthService>().deleteAccount();
                  Get.offAllNamed(AuthScreen.routeName);
                },
              );
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {
              // Navigate to Privacy Policy page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text('Do you really want to $action?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add your action logic here
                Navigator.of(context).pop(); // Close the dialog
                // Perform the action (e.g., logout or delete account)
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const Center(
        child: Text('Privacy Policy content goes here.'),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SettingsScreen(),
  ));
}
