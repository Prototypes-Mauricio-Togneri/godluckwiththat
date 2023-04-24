import 'package:flame/game.dart';
import 'package:flame/input.dart';

mixin MapHandler on FlameGame {
  final double MIN_ZOOM = 1;
  final double MAX_ZOOM = 15;
  final double ZOOM_STEP = 0.5;

  late double _startZoom;

  void _clampZoom() => camera.zoom = camera.zoom.clamp(MIN_ZOOM, MAX_ZOOM);

  bool _zoomingIn(PointerScrollInfo info) => info.scrollDelta.game.y.sign == -1;

  bool _zoomingOut(PointerScrollInfo info) => info.scrollDelta.game.y.sign == 1;

  void onMapMoved() {}

  void centerMap(Vector2 position) => camera.moveTo(position);

  void handleOnScroll(PointerScrollInfo info) {
    final bool canZoomIn = _zoomingIn(info) && camera.zoom < MAX_ZOOM;
    final bool canZoomOut = _zoomingOut(info) && camera.zoom > MIN_ZOOM;

    if (canZoomIn || canZoomOut) {
      final Vector2 offset = camera.position + (size / 2);
      final Vector2 vector =
          (info.eventPosition.game - offset) / (camera.zoom * 2);

      if (info.scrollDelta.game.y.sign > 0) {
        camera.translateBy(-vector);
      } else if (info.scrollDelta.game.y.sign < 0) {
        camera.translateBy(vector);
      }

      camera.zoom += -info.scrollDelta.game.y.sign * (camera.zoom / 10);
      _clampZoom();
      onMapMoved();
    }
  }

  void handleOnScaleStart(ScaleStartInfo info) {
    _startZoom = camera.zoom;
    onMapMoved();
  }

  void handleOnScaleUpdate(ScaleUpdateInfo info) {
    final Vector2 currentScale = info.scale.global;

    if (!currentScale.isIdentity()) {
      camera.zoom = _startZoom * currentScale.y;
      _clampZoom();
    } else {
      camera.translateBy(-info.delta.game);
      camera.snap();
    }
  }
}
