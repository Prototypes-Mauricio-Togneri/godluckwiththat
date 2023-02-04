import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor primary = Colors.blue;
  static const Color transparent = Colors.transparent;
  static const Color black = Colors.black;
  static const Color grey = Color(0xff404040);
  static const Color lightGrey = Color(0xffa0a0a0);
  static const Color white = Colors.white;
  static const Color error = Colors.red;

  static const Color screenBackground = Color(0x80000000);

  static const Color gridLine = Color(0x11888888);
  static const Color gridBackground = Color(0xff1a1a1a);
  static const Color highlightNode = Color(0xaa444444);

  static const Color resource_red = Color(0xfff44336);
  static const Color resource_green = Color(0xff4cAf50);
  static const Color resource_blue = Color(0xff2196f3);

  static const Color turret_light = Color(0xff8000ff);

  static final Paint gridPaint = Paint();

  static void init() {
    gridPaint.color = Palette.gridLine;
    gridPaint.style = PaintingStyle.stroke;
    gridPaint.strokeWidth = 0.1;
  }
}
