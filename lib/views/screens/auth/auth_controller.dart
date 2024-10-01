import 'package:english_wordle/services/auth/auth_service.dart';
import 'package:english_wordle/services/database/streak_repo.dart';
import 'package:english_wordle/views/screens/wordle_view/wordle_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  bool isLoadingGoogle = false;
  bool isLoadingAnonymously = false;
  Future<void> signUpWithGoogle() async {
    if (isLoadingGoogle) return;
    isLoadingGoogle = true;
    update();
    final authWithGoogle = await Get.find<AuthService>().signInWithGoogle();

    await authWithGoogle.fold((e) {}, _onSucessAuth);
    isLoadingGoogle = false;
    update();
  }

  Future<void> _onSucessAuth(UserCredential cred) async {
    await Get.find<StreakRepo>().init();
    Get.offAndToNamed(WordleScreen.routeName);
  }

  Future<void> signUpAnonymosly() async {
    if (isLoadingAnonymously) return;
    isLoadingAnonymously = true;
    update();
    final authWithGoogle = await Get.find<AuthService>().signInAnonymously();

    await authWithGoogle.fold((e) {}, _onSucessAuth);
    isLoadingAnonymously = false;
    update();
  }
}
