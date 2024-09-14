import 'package:english_wordle/services/auth/auth_service.dart';
import 'package:english_wordle/views/screens/wordle_view/wordle_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Future<void> signUpWithGoogle() async {
    final authWithGoogle = await Get.find<AuthService>().signInWithGoogle();

    authWithGoogle.fold((e) {}, _onSucessAuth);
  }

  void _onSucessAuth(UserCredential cred) {
    Get.toNamed(WordleScreen.routeName);
  }

  Future<void> signUpAnonymosly() async {
    final authWithGoogle = await Get.find<AuthService>().signInAnonymoslys();

    authWithGoogle.fold((e) {}, _onSucessAuth);
  }
}
