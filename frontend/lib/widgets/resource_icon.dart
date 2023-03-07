import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/utils/palette.dart';
import 'package:tensionnode/widgets/label.dart';

class ResourceIcon extends StatelessWidget {
  final String title;
  final String sprite;
  final String amount;
  final double size;

  const ResourceIcon({
    required this.title,
    required this.sprite,
    required this.amount,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: title.toUpperCase(),
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 1,
            left: 6,
            right: 5,
          ),
          textStyle: TextStyle(
            fontSize: size / 2,
            color: Palette.white,
          ),
          decoration: const BoxDecoration(
            color: Palette.black,
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: Image.asset(
              'images/$sprite',
            ),
          ),
        ),
        const HBox(5),
        Label(
          text: amount,
          size: size / 2,
        ),
      ],
    );
  }
}
