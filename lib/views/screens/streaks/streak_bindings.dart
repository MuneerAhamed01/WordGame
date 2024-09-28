import 'package:english_wordle/views/screens/streaks/streak_controller.dart';
import 'package:get/get.dart';

class StreakBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StreakController>(() => StreakController());
  }
}
