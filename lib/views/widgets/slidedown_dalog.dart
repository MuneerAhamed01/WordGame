import 'package:english_wordle/views/utils/colors.dart';
import 'package:english_wordle/views/widgets/button.dart';
import 'package:english_wordle/views/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SlidingDialog extends StatelessWidget {
  final String title;
  final VoidCallback? onPressContinue;

  const SlidingDialog({super.key, required this.title, this.onPressContinue});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 300,
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: MyColors.gray5,
            width: 6,
          ),
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [MyColors.gray5, MyColors.gray6],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const AnimatedGradientSquares(
              squareSize: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: Text(
                title,
                style: Get.textTheme.headlineMedium
                    ?.copyWith(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            if (onPressContinue != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 48,
                  child: AppButton(
                    onTap: onPressContinue,
                    label: 'Continue',
                    type: ButtonType.grey,
                  ),
                ),
              ),
            if (onPressContinue != null)
              const SizedBox(height: 12)
            else
              const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 48,
                child: AppButton(
                  onTap: () {
                    Get.back();
                  },
                  label: 'Back',
                  type: ButtonType.background,
                ),
              ),
            ),
            if (onPressContinue == null) const SizedBox(height: 24)
          ],
        ),
      ),
    );
  }
}

class SlidingDialogRoute extends GetPageRoute {
  SlidingDialogRoute({required Widget page})
      : super(
          page: () => page,
          transition: Transition.downToUp,
          transitionDuration: const Duration(milliseconds: 300),
        );

  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            color: Colors.black.withOpacity(animation.value * 0.5),
          ),
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: child,
        ),
      ],
    );
  }
}

// Example usage function
void showSlidingDialog({required String title, VoidCallback? onPressContinue}) {
  Get.to(
    () => SlidingDialog(
      title: title,
      onPressContinue: onPressContinue,
    ),
    routeName: '/sliding-dialog',
    opaque: false,
    fullscreenDialog: true,
    // transition: Transition.custom,
    // customTransition: SlidingDialogRoute(
    //   page: SlidingDialog(
    //     title: title,
    //     child: content,
    //   ),
    // ),
  );
}
