import 'dart:async';
import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/spec/bullet_spec.dart';

class Bullet extends SpriteComponent with HasGameRef<GameComponent> {
  final Node shooter;
  final BulletSpec spec;
  final Vector2 startPosition;
  final Vector2 direction;
  final double speed;
  final double range;

  Bullet({
    required this.shooter,
    required this.spec,
    required double weaponRange,
    required this.startPosition,
    required this.direction,
  })  : speed = spec.speed * Constants.NODE_SIZE,
        range = weaponRange * spec.piercing;

  @override
  Future onLoad() async {
    position = startPosition;
    sprite = await getSprite(spec.sprite);
    width = spec.width;
    height = spec.height;
    anchor = Anchor.center;
    angle = direction.screenAngle();

    add(spec.hitbox);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _moveForward(dt);
  }

  void _moveForward(double dt) {
    position += direction * speed * dt;

    final num distanceFromOrigin = position.distanceTo(startPosition);

    if (distanceFromOrigin >= range) {
      game.remove(this);
    }
  }
}
