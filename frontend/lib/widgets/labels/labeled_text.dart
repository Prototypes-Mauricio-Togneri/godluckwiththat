import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:godluckwiththat/utils/palette.dart';
import 'package:godluckwiththat/widgets/labels/label.dart';

class LabeledText extends StatelessWidget {
  final String label;
  final String text;
  final Color labelColor;
  final Color textColor;

  const LabeledText({
    required this.label,
    required this.text,
    this.labelColor = Palette.black,
    this.textColor = Palette.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Label(
          text: label,
          color: labelColor,
          weight: FontWeight.bold,
        ),
        const HBox(5),
        Label(
          text: text,
          color: textColor,
        ),
      ],
    );
  }
}
