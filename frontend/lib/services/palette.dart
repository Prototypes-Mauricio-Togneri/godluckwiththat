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

  static const Color screenBackground = Color(0x80000000);

  static const Color hpHigh = Colors.green;
  static const Color hpMedium = Colors.yellow;
  static const Color hpLow = Colors.red;
  static const Color hpContainerBackground = Color(0x88000000);

  static const Color gridLine = Color(0x55888888);
  static const Color gridBackground = Color(0xff1a1a1a);
  static const Color highlightNode = Color(0xaa444444);

  static const Color connectionLine = Colors.white;
  static const Color connectionArrow = Color(0xff777777);

  static const Color hq = Colors.white;
  static const Color mine = Color.fromARGB(255, 255, 17, 0);
  static const Color powerPlant = Colors.yellow;
  static const Color intersection = Color(0xffcccccc);
  static const Color wall = Colors.purple;
  static const Color lightTurret = Colors.purple;
  static const Color heavyTurret = Colors.purple;

  static const Color resource_red = Colors.red;
  static const Color resource_green = Colors.green;
  static const Color resource_blue = Colors.blue;
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
  static final Paint connectionBasicPaint = Paint();
  static final Paint connectionAdvancePaint = Paint();
  static final Paint connectionArrowPaint = Paint();
  static final Paint hpContainerPaint = Paint();
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

    connectionBasicPaint.style = PaintingStyle.stroke;
    connectionBasicPaint.strokeCap = StrokeCap.square;
    connectionBasicPaint.strokeJoin = StrokeJoin.miter;
    connectionBasicPaint.strokeWidth = 0.5;

    connectionAdvancePaint.style = PaintingStyle.stroke;
    connectionAdvancePaint.strokeCap = StrokeCap.square;
    connectionAdvancePaint.strokeJoin = StrokeJoin.miter;
    connectionAdvancePaint.strokeWidth = 2;

    connectionArrowPaint.style = PaintingStyle.fill;
    connectionArrowPaint.strokeCap = StrokeCap.square;
    connectionArrowPaint.strokeJoin = StrokeJoin.miter;

    hpContainerPaint.style = PaintingStyle.fill;
    hpContainerPaint.color = Palette.hpContainerBackground;

    hpPaint.style = PaintingStyle.stroke;
    hpPaint.strokeCap = StrokeCap.square;
    hpPaint.strokeJoin = StrokeJoin.miter;
    hpPaint.strokeWidth = 0.5;
  }
}
