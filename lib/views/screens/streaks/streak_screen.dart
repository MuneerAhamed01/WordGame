import 'package:english_wordle/services/database/streak_repo.dart';
import 'package:english_wordle/views/screens/settings/settings_screen.dart';
import 'package:english_wordle/views/screens/streaks/streak_controller.dart';
import 'package:english_wordle/views/utils/colors.dart';
import 'package:english_wordle/views/utils/svgs.dart';
import 'package:english_wordle/views/widgets/word_tile/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StreakScreen extends GetView<StreakController> {
  static const String routeName = '/streak';
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Steaks'),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(SettingsScreen.routeName);
            },
            icon: Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GetBuilder<StreakController>(
            builder: (_) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildCalenderNav(),
                    const SizedBox(height: 20),
                    _buildCalendarGrid(),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Svgs.streak,
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Get.find<StreakRepo>()
                                  .streakOfUser
                                  ?.streakCount
                                  .toString() ??
                              '0',
                          style: Get.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final displayMonth = controller.displayedMonth;
    final firstDayOfMonth = DateTime(displayMonth.year, displayMonth.month, 1);
    final lastDayOfMonth =
        DateTime(displayMonth.year, displayMonth.month + 1, 0);

    final firstDayOfGrid = firstDayOfMonth;

    final daysInGrid = (lastDayOfMonth.difference(firstDayOfGrid).inDays) + 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 6,
      ),
      itemCount: daysInGrid,
      itemBuilder: (context, index) {
        final date = firstDayOfGrid.add(Duration(days: index));
        final format = DateFormat('yyyy-MM-dd')
            .format(date); // Format the date as yyyy-MM-dd

        return WordTile(
          value: date.day.toString(),
          tileType: (controller.isWon[format] ?? false)
              ? WordTileType.green
              : controller.isWon[format] == false
                  ? WordTileType.orange
                  : WordTileType.none,
          shakeCallBack: (value) {},
        );
      },
    );
  }

  Row _buildCalenderNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: controller.moveToPreviousMonthIfPossible,
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 36,
          ),
        ),
        const SizedBox(width: 40),
        Text(
          '${controller.month} ${controller.year}',
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: MyColors.white,
          ),
        ),
        const SizedBox(width: 40),
        IconButton(
          onPressed: controller.moveToNextMonthIfPossible,
          icon: const Icon(
            Icons.chevron_right_outlined,
            size: 36,
          ),
        )
      ],
    );
  }
}

class WeekSelector extends StatefulWidget {
  final Function(DateTime) onWeekSelected;

  const WeekSelector({
    Key? key,
    required this.onWeekSelected,
    required this.initalselectedDate,
  }) : super(key: key);

  final DateTime initalselectedDate;

  @override
  _WeekSelectorState createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  final DateTime _currentDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  @override
  void initState() {
    _selectedDate = widget.initalselectedDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
    super.initState();
  }

  // DateTime _getWeekStart(DateTime date) {
  //   // Find the most recent Monday
  //   return date.subtract(Duration(days: (date.weekday + 6) % 7));
  // }

  // DateTime _getWeekEnd(DateTime date) {
  //   // First, find the start of the week (Sunday)

  //   if (date.weekday == 7) return date;

  //   DateTime weekStart = date.subtract(Duration(days: date.weekday % 7));
  //   // Then add 6 days to get to the end of the week (Saturday)
  //   return weekStart.add(const Duration(days: 7));
  // }

  // void _selectWeek(DateTime date) {
  //   if (date.isAfter(_getWeekEnd(_currentDate))) {
  //     return;
  //   }
  //   setState(() {
  //     _selectedDate = date;
  //   });

  //   widget.onWeekSelected(_getWeekStart(date));
  // }

  // bool _isFutureDate(DateTime date) {
  //   if (date.isAfter(_getWeekEnd(_currentDate))) {
  //     return true;
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);

    // Find the first day to display (last Monday of previous month if month doesn't start on Monday)
    final firstDayOfGrid = firstDayOfMonth;

    // Calculate the number of days to display
    final daysInGrid = (lastDayOfMonth.difference(firstDayOfGrid).inDays) +
        (lastDayOfMonth.weekday) % 7; // Add days to complete the last week

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: daysInGrid,
      itemBuilder: (context, index) {
        final date = firstDayOfGrid.add(Duration(days: index));
        return WordTile(
          value: date.day.toString(),
          tileType: WordTileType.none,
          shakeCallBack: (value) {},
        );
      },
    );
  }

  Future<void> _selectYear(BuildContext context) async {
    final int? selectedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Year'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(_displayedMonth.year - 50),
              lastDate: DateTime(_displayedMonth.year + 50),
              selectedDate: _displayedMonth,
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime.year);
              },
            ),
          ),
        );
      },
    );

    if (selectedYear != null) {
      setState(() {
        _displayedMonth = DateTime(selectedYear, _displayedMonth.month);
      });
    }
  }
}
