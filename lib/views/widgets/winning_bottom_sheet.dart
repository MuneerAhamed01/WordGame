import 'package:english_wordle/views/screens/streaks/streak_screen.dart';
import 'package:english_wordle/views/widgets/button.dart';
import 'package:english_wordle/views/widgets/tick_mark_widget.dart';
import 'package:english_wordle/views/widgets/word_tile/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WinnerBottomSheet extends StatelessWidget {
  const WinnerBottomSheet({
    super.key,
    required this.todayWord,
    this.isLost = false,
  });

  final String todayWord;

  final bool isLost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(
            height: Get.height / 0.2,
            width: Get.width,
            color: Get.theme.scaffoldBackgroundColor,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  if (isLost)
                    const Text(
                      '🥺',
                      style: TextStyle(fontSize: 60),
                    )
                  else
                    const AnimatedCheckmarkAvatar(
                      backgroundColor: Colors.green,
                    ),
                  const SizedBox(height: 60),
                  if (isLost) ...[
                    Text(
                      "Come back tomorrow we will add more words for you",
                      style: GoogleFonts.crimsonText(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Correct word is:",
                      style: GoogleFonts.crimsonText(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 12),

                  GridView.builder(
                    itemCount: 5,
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      // childAspectRatio: 1.2,
                      // mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (_, index) => WordTile(
                      value: todayWord.split('').elementAtOrNull(index) ?? '',
                      tileType: WordTileType.green,
                      shakeCallBack: (value) {},
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (!isLost) ...[
                    Text(
                      "Congrats you have found your\nToday's word",
                      style: GoogleFonts.crimsonText(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Come back tomorrow we will add more words for you",
                      style: GoogleFonts.crimsonText(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 48,
                      child: AppButton(
                        onTap: () {
                          Get.toNamed(StreakScreen.routeName);
                        },
                        label: 'Continue to the steaks',
                        type: ButtonType.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16),
                  //   child: SizedBox(
                  //     height: 48,
                  //     child: AppButton(
                  //       onTap: () {
                  //         SnackBarService.showSnackBar('message');
                  //       },
                  //       label: 'Play next game by watching an ad for 15 sec',
                  //       type: ButtonType.background,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
