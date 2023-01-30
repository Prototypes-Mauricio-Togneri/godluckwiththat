import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/map_element.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/types/direction.dart';

class BaseGameComponent extends FlameGame
    with
        HasTappables,
        HasHoverables,
        ScaleDetector,
        ScrollDetector,
        KeyboardEvents,
        MouseMovementDetector,
        HasCollisionDetection {
  final double MIN_ZOOM = 1;
  final double MAX_ZOOM = 10;
  final double ZOOM_STEP = 1;

  late double startZoom;
  Vector2? mousePosition;

  @override
  Future onLoad() async {
    camera.viewport = FixedResolutionViewport(size);
    camera.setRelativeOffset(Anchor.center);
    camera.speed = 100000000;

    return super.onLoad();
  }

  void removeComponents(Type type) => removeWhere((c) {
        c.removeWhere((c) => c.runtimeType == type);

        return c.runtimeType == type;
      });

  bool hasComponent(Type type) => children.any((c) => c.runtimeType == type);

  T getComponent<T extends Component>(Type type) =>
      children.singleWhere((c) => c.runtimeType == type) as T;

  T? closestNodeInRange<T extends Node>(
      PositionComponent origin, double range) {
    T? result;
    double minDistance = double.maxFinite;

    for (final Component component in children) {
      if ((component is T) && (component.isAlive)) {
        final double distance = origin.distance(component);

        if ((distance <= range) && (distance < minDistance)) {
          result = component;
          minDistance = distance;
        }
      }
    }

    return result;
  }

  FixedNode? getFixedNode(int i, int j) {
    for (final Component component in children) {
      if ((component is FixedNode) &&
          (component.i == i) &&
          (component.j == j)) {
        return component;
      }
    }

    return null;
  }

  MapElement? getMapElement(int i, int j) {
    for (final Component component in children) {
      if ((component is MapElement) &&
          (component.i == i) &&
          (component.j == j)) {
        return component;
      }
    }

    return null;
  }

  void clampZoom() {
    camera.zoom = camera.zoom.clamp(MIN_ZOOM, MAX_ZOOM);
  }

  bool zoomingIn(PointerScrollInfo info) => info.scrollDelta.game.y.sign == -1;

  bool zoomingOut(PointerScrollInfo info) => info.scrollDelta.game.y.sign == 1;

  @override
  void onScroll(PointerScrollInfo info) {
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

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    onMapClicked(_toGridPosition(info.eventPosition.game));
    super.onTapUp(pointerId, info);
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    startZoom = camera.zoom;
    onMapMoved();
  }

  void onMapMoved() {}

  void onMapClicked(Vector2 position) {}

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

  void onKeyPressed(LogicalKeyboardKey key) {}

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final bool isKeyDown = event is RawKeyDownEvent;
    final bool isEscape = keysPressed.contains(LogicalKeyboardKey.escape);
    final bool isSpace = keysPressed.contains(LogicalKeyboardKey.space);
    final bool isUp = keysPressed.contains(LogicalKeyboardKey.keyW);
    final bool isDown = keysPressed.contains(LogicalKeyboardKey.keyS);
    final bool isLeft = keysPressed.contains(LogicalKeyboardKey.keyA);
    final bool isRight = keysPressed.contains(LogicalKeyboardKey.keyD);

    if (isUp && isKeyDown) {
      _moveMap(Direction.up);
    } else if (isDown && isKeyDown) {
      _moveMap(Direction.down);
    } else if (isLeft && isKeyDown) {
      _moveMap(Direction.left);
    } else if (isRight && isKeyDown) {
      _moveMap(Direction.right);
    }

    if (isEscape && isKeyDown) {
      onKeyPressed(LogicalKeyboardKey.escape);
      return KeyEventResult.handled;
    } else if (isSpace && isKeyDown) {
      onKeyPressed(LogicalKeyboardKey.space);
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }

  void _moveMap(Direction direction) {
    final double x = (direction == Direction.left)
        ? Constants.MAP_MOVEMENT
        : ((direction == Direction.right) ? -Constants.MAP_MOVEMENT : 0);

    final double y = (direction == Direction.up)
        ? Constants.MAP_MOVEMENT
        : ((direction == Direction.down) ? -Constants.MAP_MOVEMENT : 0);

    final Vector2 offset = Vector2(x, y);
    final Vector2 vector = offset;

    camera.translateBy(-vector);
  }

  @override
  Color backgroundColor() => const Color(0xff1a1a1a);

  @override
  void onMouseMove(PointerHoverInfo info) {
    super.onMouseMove(info);
    mousePosition = _toSnapPosition(info.eventPosition.game);
  }

  Vector2 _toSnapPosition(Vector2 point) {
    final Vector2 position = Vector2(
      point.x.toInt() + (Constants.NODE_SIZE / 2),
      point.y.toInt() + (Constants.NODE_SIZE / 2),
    );
    final double x = position.x - (position.x % Constants.NODE_SIZE);
    final double y = position.y - (position.y % Constants.NODE_SIZE);

    return Vector2(x, y);
  }

  Vector2 _toGridPosition(Vector2 point) {
    final pointSnapped = _toSnapPosition(point);

    return Vector2(
      (pointSnapped.x ~/ Constants.NODE_SIZE).toDouble(),
      (pointSnapped.y ~/ Constants.NODE_SIZE).toDouble(),
    );
  }
}
