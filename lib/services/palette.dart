import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor primary = Colors.blue;
  static const Color transparent = Colors.transparent;
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color red = Colors.red;
  static const Color blue = Colors.blue;
  static const Color green = Colors.green;

  static const Color gridLine = Color(0x55888888);
  static const Color gridBackground = Color(0xff1a1a1a);
  static const Color highlightNode = Color(0xaaffffff);

  static const Color hq = Colors.white;
  static const Color mine = Color.fromARGB(255, 255, 17, 0);
  static const Color powerPlant = Colors.yellow;
  static const Color defense = Colors.green;
  static const Color intersection = Colors.white;

  static const Color resource1 = Colors.red;
  static const Color resource2 = Colors.green;
  static const Color resource3 = Colors.blue;
  static const Color energy = Colors.amber;

  static const Color hudBackground = Color(0xee555555);
  static const Color hudButton = Color(0xff000000);
  static const Color hudResourceIndicator = Color(0x44000000);

  static final Paint gridPaint = Paint();
  static final Paint diamondHollowPaint = Paint();
  static final Paint diamondFilledPaint = Paint();
  static final Paint squareHollowPaint = Paint();
  static final Paint squareFilledPaint = Paint();
  static final Paint circleHollowPaint = Paint();
  static final Paint circleFilledPaint = Paint();
  static final Paint lanePaint = Paint();
  static final Paint hpPaint = Paint();

  static void init() {
    gridPaint.color = Palette.gridLine;
    gridPaint.style = PaintingStyle.stroke;
    gridPaint.strokeWidth = 0.1;

    diamondHollowPaint.style = PaintingStyle.stroke;
    diamondHollowPaint.strokeCap = StrokeCap.square;
    diamondHollowPaint.strokeJoin = StrokeJoin.miter;
    diamondHollowPaint.strokeWidth = 0.5;

    diamondFilledPaint.style = PaintingStyle.fill;
    diamondFilledPaint.strokeCap = StrokeCap.square;
    diamondFilledPaint.strokeJoin = StrokeJoin.miter;

    squareHollowPaint.style = PaintingStyle.stroke;
    squareHollowPaint.strokeCap = StrokeCap.square;
    squareHollowPaint.strokeJoin = StrokeJoin.miter;
    squareHollowPaint.strokeWidth = 0.5;

    squareFilledPaint.style = PaintingStyle.fill;
    squareFilledPaint.strokeCap = StrokeCap.square;
    squareFilledPaint.strokeJoin = StrokeJoin.miter;

    circleHollowPaint.style = PaintingStyle.stroke;
    circleHollowPaint.strokeCap = StrokeCap.square;
    circleHollowPaint.strokeJoin = StrokeJoin.miter;
    circleHollowPaint.strokeWidth = 0.5;

    circleFilledPaint.style = PaintingStyle.fill;
    circleFilledPaint.strokeCap = StrokeCap.square;
    circleFilledPaint.strokeJoin = StrokeJoin.miter;

    lanePaint.style = PaintingStyle.stroke;
    lanePaint.strokeCap = StrokeCap.square;
    lanePaint.strokeJoin = StrokeJoin.miter;
    lanePaint.strokeWidth = 0.5;

    hpPaint.style = PaintingStyle.stroke;
    hpPaint.strokeCap = StrokeCap.square;
    hpPaint.strokeJoin = StrokeJoin.miter;
    hpPaint.strokeWidth = 0.5;
  }
}
