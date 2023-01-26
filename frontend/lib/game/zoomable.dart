import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class Zoomable extends FlameGame with ScrollDetector, ScaleDetector {
  final double MIN_ZOOM = 1;
  final double MAX_ZOOM = 10;
  final double ZOOM_STEP = 1;

  late double startZoom;

  @override
  Future onLoad() async {
    camera.viewport = FixedResolutionViewport(size);
    camera.setRelativeOffset(Anchor.center);
    camera.speed = 100000000;

    return super.onLoad();
  }

  void clampZoom() {
    camera.zoom = camera.zoom.clamp(MIN_ZOOM, MAX_ZOOM);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    if ((info.scrollDelta.game.y.sign == -1) || (camera.zoom > 1)) {
      final Vector2 offset = camera.position + (size / 2);
      final Vector2 vector =
          (info.eventPosition.game - offset) / (camera.zoom * 2);

      if (info.scrollDelta.game.y.sign > 0) {
        camera.translateBy(-vector);
      } else if (info.scrollDelta.game.y.sign < 0) {
        camera.translateBy(vector);
      }

      camera.zoom += -info.scrollDelta.game.y.sign * ZOOM_STEP;
      clampZoom();
    }
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    startZoom = camera.zoom;
    onScrollEvent();
  }

  void onScrollEvent() {}

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
