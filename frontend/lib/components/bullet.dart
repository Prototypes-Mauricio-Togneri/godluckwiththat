import 'dart:async';
import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/assets.dart';

class Bullet extends SpriteComponent with HasGameRef<GameComponent> {
  final Vector2 target;
  final double speed;

  Bullet({
    required super.position,
    required this.target,
    required this.speed,
  });

  @override
  FutureOr onLoad() async {
    sprite = await getSprite(Assets.IMAGES_BULLET);
    width = Constants.BULLET_SIZE;
    height = Constants.BULLET_SIZE;
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _moveForward(dt);
  }

  void _moveForward(double dt) {
    /*switch (direction) {
      case Direction.up:
        y -= dt * speed;
        break;
      case Direction.down:
        y += dt * speed;
        break;
      case Direction.left:
        x -= dt * speed;
        break;
      case Direction.right:
        x += dt * speed;
        break;
    }*/
  }
}
