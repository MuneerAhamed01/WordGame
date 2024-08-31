import 'package:english_wordle/views/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'custom_keybord_helper.dart';

class CustomKeyboard extends StatefulWidget {
  final Function(String) onKeyPressed;
  final Function() onEnterPressed;
  final Function() onBackspacePressed;
  final List<String> orangedList;
  final List<String> greenedList;
  final List<String> disabledList;

  const CustomKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onEnterPressed,
    required this.onBackspacePressed,
    this.orangedList = const [],
    this.greenedList = const [],
    this.disabledList = const [],
  });

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard>
    with CustomKeybordHelper {
  Widget _buildKey(String key) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0).copyWith(bottom: 6),
        child: InkWell(
          onTap: () {
            widget.onKeyPressed(key);
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: backgroundColor(key),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                key,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor(key),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWideButton(String label, VoidCallback onPressed) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(2.0).copyWith(bottom: 6),
        child: InkWell(
          onTap: onPressed,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...keyboardLayout
            .map((row) => Row(children: row.map(_buildKey).toList())),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWideButton('Enter', widget.onEnterPressed),
            _buildWideButton('⌫', widget.onBackspacePressed),
          ],
        ),
      ],
    );
  }
}
