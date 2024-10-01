import 'package:english_wordle/models/streak_model.dart';
import 'package:english_wordle/services/database/streak_repo.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StreakController extends GetxController {
  DateTime displayedMonth = DateTime.now();

  String get month => DateFormat('MMMM').format(displayedMonth);

  String get year => DateFormat('y').format(displayedMonth);

  StreakRepo get _streakRepo => Get.find<StreakRepo>();

  List<StreakModel> monthsStreak = [];

  bool isLoading = false;

  Map<String, bool> isWon = {};

  void moveToNextMonthIfPossible() {
    if (displayedMonth.month == 12) {
      displayedMonth = DateTime(displayedMonth.year + 1, 1);
    } else {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month + 1);
    }
    getMyStreak();
    update();
  }

  void moveToPreviousMonthIfPossible() {
    if (displayedMonth.month == 1) {
      displayedMonth = DateTime(displayedMonth.year - 1, 12);
    } else {
      displayedMonth = DateTime(displayedMonth.year, displayedMonth.month - 1);
    }
    getMyStreak();
    update();
  }

  Future<void> getMyStreak() async {
    isLoading = true;
    update();
    final monthsStreak = await _streakRepo.getStreaksByMonth(displayedMonth);
    isLoading = false;
    this.monthsStreak = monthsStreak;

    for (var streak in monthsStreak) {
      final formatter = DateFormat('yyyy-MM-dd').format(streak.date);
      isWon[formatter] = streak.isWon;
    }

    update();
  }

  @override
  void onInit() {
    getMyStreak();
    super.onInit();
  }
}
