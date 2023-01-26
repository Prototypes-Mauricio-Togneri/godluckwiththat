import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game.dart';

class MenuButtonComponent extends SpriteGroupComponent<ButtonState>
    with HasGameRef<MyGame>, Tappable {
  final String spriteDown;
  final String spriteUp;
  final VoidCallback onClick;

  MenuButtonComponent({
    required double width,
    required double height,
    required PositionType positionType,
    required Vector2 position,
    required this.spriteDown,
    required this.spriteUp,
    required this.onClick,
    Anchor anchor = Anchor.topLeft,
    int priority = 0,
  }) {
    this.width = width;
    this.height = height;
    this.positionType = positionType;
    this.position = position;
    this.anchor = anchor;
    this.priority = priority;
  }

  @override
  Future onLoad() async {
    sprites = {
      ButtonState.down: await getSprite(spriteDown),
      ButtonState.up: await getSprite(spriteUp),
    };

    current = ButtonState.up;

    return super.onLoad();
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
