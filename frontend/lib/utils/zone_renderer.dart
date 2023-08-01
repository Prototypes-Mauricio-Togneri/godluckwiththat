import 'dart:math';
import 'dart:ui';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/utils/images.dart';
import 'package:gatewayguardians/utils/palette.dart';
import 'package:gatewayguardians/widgets/map_widget.dart';

class TileRenderer {
  final int x;
  final int y;
  final Paint paintImage = Paint();
  final Paint paintSelected = Paint();

  TileRenderer({
    required this.x,
    required this.y,
  }) {
    paintSelected.color = Palette.white;
    paintSelected.style = PaintingStyle.stroke;
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
    required Tile tile,
    required Canvas canvas,
    required Size size,
    required double tileWidth,
    required double tileHeight,
    required double topGap,
  }) {
    paintImage.color = Palette.grey;
    paintImage.style = PaintingStyle.fill;

    final double i = (size.width / 2) + ((x - y) * (tileWidth / 2));
    final double j = topGap + ((x + y) * (tileHeight / 2));

    final Path path = Path();
    path.moveTo(i, j - (tileHeight / 2));
    path.lineTo(i + (tileWidth / 2), j);
    path.lineTo(i, j + (tileHeight / 2));
    path.lineTo(i - (tileWidth / 2), j);
    path.close();
    canvas.drawPath(path, paintImage);

    _drawImageFull(
      canvas: canvas,
      offset: Offset(i - (tileWidth / 2), j - (tileHeight / 2)),
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      image: Images.image(tile.tileType.sprite),
    );

    if (tile.patchType != null) {
      _drawImageFull(
        canvas: canvas,
        offset: Offset(i - (tileWidth / 2), j - (tileHeight / 2)),
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        image: Images.image(tile.patchType!.sprite),
      );
    }
  }

  void renderSelected({
    required Canvas canvas,
    required int canvasWidth,
    required double tileWidth,
    required double tileHeight,
    required double topGap,
  }) {
    paintSelected.strokeWidth = canvasWidth / 700;

    final double i = (canvasWidth / 2) + ((x - y) * (tileWidth / 2));
    final double j = topGap + ((x + y) * (tileHeight / 2));

    final Path path = Path();
    path.moveTo(i, j - (tileHeight / 2));
    path.lineTo(i + (tileWidth / 2), j);
    path.lineTo(i, j + (tileHeight / 2));
    path.lineTo(i - (tileWidth / 2), j);
    path.close();
    canvas.drawPath(path, paintSelected);
  }

  void _drawImageFull({
    required Canvas canvas,
    required Offset offset,
    required double tileWidth,
    required double tileHeight,
    required Image image,
  }) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(offset.dx, offset.dy, tileWidth, tileHeight),
      paintImage,
    );
  }
}
