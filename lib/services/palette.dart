import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor primary = Colors.blue;
  static const Color transparent = Colors.transparent;
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;

  static const Color gridLine = Color(0x44aaaaaa);
  static const Color gridBackground = Color(0xff222222);
  static const Color highlightNode = Color(0xaaffffff);

  static const Color hq = Colors.blue;
  static const Color mine1 = Colors.yellow;
  static const Color hudBackground = Color(0xcc333333);
  static const Color hudResourceIndicator = Color(0x44000000);

  static Paint gridPaint = Paint();

  static void init() {
    gridPaint = Paint();
    gridPaint.color = Palette.gridLine;
    gridPaint.style = PaintingStyle.stroke;
    gridPaint.strokeWidth = 0.1;
  }
}
