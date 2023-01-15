import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:tensionnode/engine/mine.dart';

class MyGame extends FlameGame with ScrollDetector, ScaleDetector {
  final double MIN_ZOOM = 1;
  final double MAX_ZOOM = 10;
  final double ZOOM_STEP = 1;

  late double startZoom;

  @override
  Future<void> onLoad() async {
    camera.viewport = FixedResolutionViewport(size);
    camera.setRelativeOffset(Anchor.center);
    camera.speed = 100;

    add(Mine());
  }

  @override
  Color backgroundColor() => const Color(0xffaaaaaa);

  void clampZoom() {
    camera.zoom = camera.zoom.clamp(MIN_ZOOM, MAX_ZOOM);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    camera.zoom += -info.scrollDelta.game.y.sign * ZOOM_STEP;
    clampZoom();
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    startZoom = camera.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final Vector2 currentScale = info.scale.global;

    if (!currentScale.isIdentity()) {
      camera.zoom = startZoom * currentScale.y;
      clampZoom();
    } else {
      camera.translateBy(-info.delta.game);
      camera.snap();
    }
  }
}
