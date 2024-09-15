import 'package:english_wordle/views/screens/leaderboard/leaderbord_controller.dart';
import 'package:get/get.dart';

class LeaderboardBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaderboardController>(() => LeaderboardController());
  }
}
