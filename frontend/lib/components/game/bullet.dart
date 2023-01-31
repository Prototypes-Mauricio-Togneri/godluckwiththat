import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/spec/bullet_spec.dart';

class Bullet extends SpriteComponent with HasGameRef<GameComponent> {
  final BulletSpec spec;
  final Vector2 startPosition;
  final Vector2 direction;

  Bullet({
    required this.spec,
    required this.startPosition,
    required this.direction,
  });

  @override
  FutureOr onLoad() async {
    position = startPosition;
    sprite = await getSprite(spec.image);
    width = spec.width;
    height = spec.height;
    anchor = Anchor.center;
    angle = direction.screenAngle();

    add(CircleHitbox());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _moveForward(dt);
  }

  void _moveForward(double dt) {
    position += direction * spec.speed * dt;

    final double distanceFromOrigin = position.distanceTo(startPosition);

    if (distanceFromOrigin >= spec.range) {
      game.remove(this);
    }
  }
}
