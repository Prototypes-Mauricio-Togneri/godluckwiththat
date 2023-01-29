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
    // TODO(momo): improvement: draw one single path instead of individual lines
    final Rect viewport = Rect.fromLTWH(
      camera.position.x,
      camera.position.y,
      camera.viewport.effectiveSize.x,
      camera.viewport.effectiveSize.y,
    );

    final int left = (viewport.left ~/ Constants.NODE_SIZE) - 1;
    final int right = (viewport.right ~/ Constants.NODE_SIZE) + 1;

    for (int i = left; i < right; i++) {
      final double x = (i * Constants.NODE_SIZE).toDouble();

      if ((x >= viewport.left) && (x <= viewport.right)) {
        canvas.drawLine(
          Offset(x, viewport.top),
          Offset(x, viewport.bottom),
          Palette.gridPaint,
        );
      }
    }

    final int top = (viewport.top ~/ Constants.NODE_SIZE) - 1;
    final int bottom = (viewport.bottom ~/ Constants.NODE_SIZE) + 1;

    for (int j = top; j < bottom; j++) {
      final double y = (j * Constants.NODE_SIZE).toDouble();

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
