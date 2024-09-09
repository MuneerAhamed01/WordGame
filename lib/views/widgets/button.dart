import 'package:english_wordle/views/utils/colors.dart';
import 'package:english_wordle/views/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

enum ButtonType { grey, background }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onTap,
    this.label,
    this.icon,
    this.iconSize,
    this.labelBuilder,
    this.backgroundColor,
    this.type = ButtonType.grey,
    this.iconPadding,
    this.iconColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.onTapIcon,
  });

  final VoidCallback? onTap;

  final VoidCallback? onTapIcon;

  final String? label;

  final IconData? icon;

  final ButtonType type;

  final double? iconSize;

  final Widget? labelBuilder;

  final Color? backgroundColor;

  final Color? iconColor;

  final EdgeInsets? iconPadding;

  final bool isDisabled;

  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Material(
      // color: type == ButtonType.grey
      //     ? MyColors.gray
      //     : MyColors.gray5,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // splashColor:
        //     FMPButtonStyle.textButton == style ? Colors.transparent : null,
        onTap: isDisabled ? null : onTap,
        child: Center(child: _buttonLabel(context)),
      ),
    );
  }

  Widget _buttonLabel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [
            if (type == ButtonType.grey) ...[
              MyColors.gray5,
              MyColors.gray5,
            ] else ...[
              MyColors.gray6,
              MyColors.gray6,
            ]
          ])),
      width: double.infinity,
      child: isLoading
          ? _buildLoading()
          : Center(
              child: Text(
                label!,
                textScaler: const TextScaler.linear(1.0),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
            ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: AppLoadingIndicator(),
    );
  }

  // Color _backgroundColor(context) {
  //   if (isDisabled) {
  //     return Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5);
  //   }

  //   if (backgroundColor != null) return backgroundColor!;

  //   if (style == FMPButtonStyle.primary) {
  //     return Theme.of(context).colorScheme.onPrimaryContainer;
  //   }
  //   if (style == FMPButtonStyle.chip) {
  //     return Theme.of(context).colorScheme.primaryContainer;
  //   }
  //   if (style == FMPButtonStyle.textButton) {
  //     return Colors.transparent;
  //   }
  //   return Theme.of(context).colorScheme.onPrimary;
  // }
}
