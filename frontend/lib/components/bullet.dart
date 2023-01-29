import 'dart:async';
import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/assets.dart';

class Bullet extends SpriteComponent with HasGameRef<GameComponent> {
  final Vector2 originalPosition;
  final Vector2 direction;
  final double speed;
  final double range;

  Bullet({
    required this.originalPosition,
    required this.direction,
    required this.speed,
    required this.range,
  });

  @override
  FutureOr onLoad() async {
    position = originalPosition;
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
    position += direction * speed * dt;

    final double distanceFromOrigin = position.distanceTo(originalPosition);

    if (distanceFromOrigin >= range) {
      game.remove(this);
    }
  }
}
