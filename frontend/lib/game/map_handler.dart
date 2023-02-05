import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/map_component.dart';
import 'package:tensionnode/extensions/logical_keyboard_key_extension.dart';
import 'package:tensionnode/models/map_tile.dart';

mixin MapHandler on FlameGame {
  final double MIN_ZOOM = 1;
  final double MAX_ZOOM = 10;
  final double ZOOM_STEP = 1;

  late double _startZoom;
  late MapComponent _map;
  Vector2? _mousePosition;

  @override
  Future onLoad() async {
    camera.viewport = FixedResolutionViewport(size);
    camera.setRelativeOffset(Anchor.center);
    camera.speed = double.maxFinite;

    return super.onLoad();
  }

  bool get hasMousePosition => _mousePosition != null;

  Vector2 get mousePosition => _mousePosition!;

  Future<MapComponent> getMap(String content) async {
    return _map = await MapComponent.load(content);
  }

  MapTile getTile({
    required int i,
    required int j,
  }) =>
      _map.tile(
        i: i,
        j: j,
      );

  void clampZoom() {
    camera.zoom = camera.zoom.clamp(MIN_ZOOM, MAX_ZOOM);
  }

  bool zoomingIn(PointerScrollInfo info) => info.scrollDelta.game.y.sign == -1;

  bool zoomingOut(PointerScrollInfo info) => info.scrollDelta.game.y.sign == 1;

  void onMapMoved() {}

  void onMapClicked(Vector2 position) {}

  void onKeyPressed(LogicalKeyboardKey key) {}

  void centerMap(Vector2 position) => camera.moveTo(position);

  Vector2 mapMovement(Set<LogicalKeyboardKey> keysPressed) {
    final double x = keysPressed.isLeft
        ? Constants.MAP_MOVEMENT
        : (keysPressed.isRight ? -Constants.MAP_MOVEMENT : 0);

    final double y = keysPressed.isUp
        ? Constants.MAP_MOVEMENT
        : (keysPressed.isDown ? -Constants.MAP_MOVEMENT : 0);

    return Vector2(x, y);
  }

  Vector2 toSnapPosition(Vector2 point) {
    final Vector2 position = Vector2(
      point.x.toInt() + (Constants.NODE_SIZE / 2),
      point.y.toInt() + (Constants.NODE_SIZE / 2),
    );
    final double x = position.x - (position.x % Constants.NODE_SIZE);
    final double y = position.y - (position.y % Constants.NODE_SIZE);

    return Vector2(x, y);
  }

  Vector2 toGridPosition(Vector2 point) {
    final pointSnapped = toSnapPosition(point);

    return Vector2(
      (pointSnapped.x ~/ Constants.NODE_SIZE).toDouble(),
      (pointSnapped.y ~/ Constants.NODE_SIZE).toDouble(),
    );
  }

  void handleOnScroll(PointerScrollInfo info) {
    final bool canZoomIn = zoomingIn(info) && camera.zoom < MAX_ZOOM;
    final bool canZoomOut = zoomingOut(info) && camera.zoom > MIN_ZOOM;

    if (canZoomIn || canZoomOut) {
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
      clampZoom();
    } else {
      camera.translateBy(-info.delta.game);
      camera.snap();
    }
  }

  void handleOnMouseMove(PointerHoverInfo info) {
    _mousePosition = toSnapPosition(info.eventPosition.game);
  }

  KeyEventResult handleOnKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final bool isKeyDown = event is RawKeyDownEvent;

    if (keysPressed.isDirectional) {
      camera.translateBy(-mapMovement(keysPressed));
      return KeyEventResult.handled;
    } else if (keysPressed.isEscape && isKeyDown) {
      onKeyPressed(LogicalKeyboardKey.escape);
      return KeyEventResult.handled;
    } else if (keysPressed.isSpace && isKeyDown) {
      onKeyPressed(LogicalKeyboardKey.space);
      return KeyEventResult.handled;
    } else if (keysPressed.isK && isKeyDown) {
      centerMap(Vector2(0, 0));
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }
}
