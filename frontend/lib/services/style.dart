import 'package:flame/text.dart';
import 'package:flutter/painting.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/services/palette.dart';

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
  }) =>
      TextPaint(
        style: TextStyle(
          fontSize: size,
          color: color,
          height: 1.5,
        ),
      );
}
