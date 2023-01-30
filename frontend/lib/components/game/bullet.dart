import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/types/bullet_type.dart';

class Bullet extends SpriteComponent with HasGameRef<GameComponent> {
  final BulletType type;
  final Vector2 startPosition;
  final Vector2 direction;

  Bullet({
    required this.type,
    required this.startPosition,
    required this.direction,
  });

  @override
  FutureOr onLoad() async {
    position = startPosition;
    sprite = await getSprite(type.path);
    width = type.width;
    height = type.height;
    anchor = Anchor.center;
    angle = direction.screenAngle() + (pi / 2);

    add(CircleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _moveForward(dt);
  }

  void _moveForward(double dt) {
    position += direction * type.speed * dt;

    final double distanceFromOrigin = position.distanceTo(startPosition);

    if (distanceFromOrigin >= type.range) {
      game.remove(this);
    }
  }
}
