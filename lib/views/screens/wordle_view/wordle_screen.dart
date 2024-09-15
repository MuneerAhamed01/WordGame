import 'package:english_wordle/views/screens/leaderboard/leaderboard_screen.dart';
import 'package:english_wordle/views/screens/wordle_view/wordle_controller.dart';
import 'package:english_wordle/views/utils/svgs.dart';
import 'package:english_wordle/views/widgets/custom_keybord/custom_keybord.dart';
import 'package:english_wordle/views/widgets/shimmer_widget.dart';
import 'package:english_wordle/views/widgets/word_tile/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WordleScreen extends GetView<WordleController> {
  const WordleScreen({super.key});

  static const String routeName = '/wordleScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 16, top: 6),
        //   child:
        // ),
        leading: GestureDetector(
          onTap: () {
            Get.toNamed(LeaderboardScreen.routeName);
          },
          child: const Icon(Icons.menu_outlined),
        ),
        title: const Text('WordSchool'),
        actions: [
          Text(
            '1',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            Svgs.streak,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<WordleController>(
          id: WordleController.reBuildScreen,
          builder: (context) {
            if (controller.isLoading) return _buildLoadingBody();

            return _buildWordBody();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GridView.builder(
          itemCount: 5 * 5,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          shrinkWrap: true,
          itemBuilder: (_, index) => GetBuilder<WordleController>(
            id: WordleController.reBuildCardId(index.toString()),
            builder: (context) {
              return ShimmerGridItem(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWordBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        // const AnimatedCheckmarkAvatar(
        //   size: 100,
        //   checkmarkColor: Colors.white,
        //   backgroundColor: Colors.green,
        //   checkmarkDuration: Duration(milliseconds: 1000),
        //   zoomDuration: Duration(milliseconds: 500),
        // ),
        GridView.builder(
          itemCount: 5 * 5,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          shrinkWrap: true,
          itemBuilder: (_, index) => GetBuilder<WordleController>(
            id: WordleController.reBuildCardId(index.toString()),
            builder: (context) {
              return WordTile(
                value: controller.typedValues.elementAtOrNull(index) ?? '',
                tileType: controller.typeOfTheContainer(
                  controller.typedValues.elementAtOrNull(index) ?? '',
                  _getRangeValue(index),
                  index,
                ),
                shakeCallBack: (value) {
                  if (controller.listOfShakeItems[index] == null) {
                    controller.listOfShakeItems[index] = value;
                  }
                },
              );
            },
          ),
        ),
        _buildIndicator(),
        const Spacer(),
        GetBuilder<WordleController>(
          id: WordleController.reBuildKeyBord,
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: CustomKeyboard(
                controller: controller.audioController,
                onKeyPressed: controller.addTypedValue,
                onBackspacePressed: controller.removeValue,
                onEnterPressed: controller.onPressEnter,
                disabledList: controller.disabledValues,
                greenedList: controller.greenValues,
                orangedList: controller.orangeValues,
              ),
            );
          },
        )
      ],
    );
  }

  GetBuilder<WordleController> _buildIndicator() {
    return GetBuilder<WordleController>(
      id: WordleController.reBuildIndicator,
      builder: (_) {
        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 24, top: 16),
            child: Text(
              '${controller.currentSection} / 5',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        );
      },
    );
  }

  int _getRangeValue(int number) {
    // Calculate the group value
    int groupValue = ((number) / 5).floor() + 1;
    return groupValue;
  }
}
