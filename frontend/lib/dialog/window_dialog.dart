import 'package:flutter/material.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/widgets/label.dart';

class WindowDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const WindowDialog({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: Palette.grey,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Label(
                text: title,
                color: Palette.white,
                size: 12,
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
