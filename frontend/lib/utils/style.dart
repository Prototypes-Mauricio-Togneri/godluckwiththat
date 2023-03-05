import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/utils/palette.dart';

class Style {
  static TextRenderer textRenderer({
    required double size,
    Color color = Palette.white,
  }) =>
      TextPaint(
        style: TextStyle(
          fontSize: size,
          fontFamily: Constants.FONT_NAME,
          color: color,
        ),
      );

  static TextRenderer debugTextRenderer({
    required double size,
    Color color = Palette.white,
  }) {
    final double border = size / 25;

    return TextPaint(
      style: TextStyle(
        fontSize: size,
        height: 1.5,
        color: Colors.red,
        shadows: [
          Shadow(
            color: Colors.yellow,
            offset: Offset(border, border),
          ),
          Shadow(
            color: Colors.yellow,
            offset: Offset(-border, border),
          ),
          Shadow(
            color: Colors.yellow,
            offset: Offset(border, -border),
          ),
          Shadow(
            color: Colors.yellow,
            offset: Offset(-border, -border),
          ),
        ],
      ),
    );
  }
}
