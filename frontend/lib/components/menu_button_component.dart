import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';

class MenuButtonComponent extends SpriteGroupComponent<ButtonState>
    with HasGameRef<GameComponent>, Tappable {
  final Vector2 originalSize;
  final Vector2 originalPosition;
  final String spriteDown;
  final String spriteUp;
  final VoidCallback onClick;
  final bool resizeWithZoom;

  MenuButtonComponent({
    required this.originalSize,
    required this.originalPosition,
    required PositionType positionType,
    required this.spriteDown,
    required this.spriteUp,
    required this.onClick,
    Anchor anchor = Anchor.topLeft,
    int priority = 0,
    this.resizeWithZoom = false,
  }) {
    this.positionType = positionType;
    this.anchor = anchor;
    this.priority = priority;
  }

  @override
  Future onLoad() async {
    _updateSizeAndPosition();

    sprites = {
      ButtonState.down: await getSprite(spriteDown),
      ButtonState.up: await getSprite(spriteUp),
    };

    current = ButtonState.up;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (resizeWithZoom) {
      _updateSizeAndPosition();
    }
  }

  void _updateSizeAndPosition() {
    width = originalSize.x / game.camera.zoom;
    height = originalSize.y / game.camera.zoom;

    position.x = originalPosition.x / game.camera.zoom;
    position.y = originalPosition.y / game.camera.zoom;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    current = ButtonState.up;

    onClick();

    return true;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    current = ButtonState.down;

    return true;
  }
}
