import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/services/palette.dart';

class Background extends Component {
  final Camera camera;

  Background(this.camera);

  @override
  void render(Canvas canvas) {
    final Rect viewport = Rect.fromLTWH(
      camera.position.x,
      camera.position.y,
      camera.viewport.effectiveSize.x,
      camera.viewport.effectiveSize.y,
    );

    for (int i = -10000; i < 10000; i++) {
      final double x = (i * Constants.CELL_SIZE).toDouble();

      if ((x >= viewport.left) && (x <= viewport.right)) {
        canvas.drawLine(
          Offset(x, viewport.top),
          Offset(x, viewport.bottom),
          Palette.gridPaint,
        );
      }
    }

    for (int j = -10000; j < 10000; j++) {
      final double y = (j * Constants.CELL_SIZE).toDouble();

      if ((y >= viewport.top) && (y <= viewport.bottom)) {
        canvas.drawLine(
          Offset(viewport.left, y),
          Offset(viewport.right, y),
          Palette.gridPaint,
        );
      }
    }

    super.render(canvas);
  }
}
