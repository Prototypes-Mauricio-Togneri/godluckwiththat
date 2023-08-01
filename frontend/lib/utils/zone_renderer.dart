import 'dart:math';
import 'dart:ui';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/map_widget.dart';

class ZoneRenderer {
  final int x;
  final int y;
  final Paint paintTest = Paint();

  ZoneRenderer({
    required this.x,
    required this.y,
  }) {
    paintTest.color = Palette.white;
    paintTest.style = PaintingStyle.stroke;
  }

  // https://math.stackexchange.com/questions/312403/how-do-i-determine-if-a-point-is-within-a-rhombus
  bool isInside(Offset offset) {
    final double qx =
        (MapPainter.CANVAS_WIDTH / 2) + ((x - y) * (MapPainter.TILE_WIDTH / 2));
    final double qy =
        MapPainter.TOP_GAP + ((x + y) * (MapPainter.TILE_HEIGHT / 2));
    // final double a = MapPainter.TILE_WIDTH / 2;
    // final double b = MapPainter.TILE_HEIGHT / 2;

    // Q = 0.5*(A + C);           // center point
    // a = 0.5*distance(A,C);     // half-width (in the x-direction)
    // b = 0.5*distance(B,D);     // half-height (y-direction)
    // U = (C - A)/(2*a);         // unit vector in x-direction
    // V = (D - B)/(2*b);         // unit vector in y-direction

    // W = P - Q;
    // xabs = abs(W*U);    // here W*U is the dot product of W and U
    // yabs = abs(W*V);    // here W*V is the dot product of W and V
    // if (xabs/a + yabs/b <= 1) then inside = true;

    final double distance =
        sqrt(pow(offset.dx - qx, 2) + pow(offset.dy - qy, 2));

    return distance <= (MapPainter.TILE_HEIGHT / 2);
  }

  void render({
    required Canvas canvas,
    required int canvasWidth,
    required double tileWidth,
    required double tileHeight,
    required double topGap,
  }) {
    paintTest.strokeWidth = canvasWidth / 700;

    final double i = (canvasWidth / 2) + ((x - y) * (tileWidth / 2));
    final double j = topGap + ((x + y) * (tileHeight / 2));

    final Path path = Path();
    path.moveTo(i, j - (tileHeight / 2));
    path.lineTo(i + (tileWidth / 2), j);
    path.lineTo(i, j + (tileHeight / 2));
    path.lineTo(i - (tileWidth / 2), j);
    path.close();
    canvas.drawPath(path, paintTest);
  }
}
