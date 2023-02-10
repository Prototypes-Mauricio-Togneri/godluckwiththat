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
  double spriteRatio = 1;

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
    sprite = await getSprite(spec.spriteBase);
    width = spec.width;
    height = spec.height;
    anchor = Anchor.center;
    spriteRatio = width / sprite!.image.width;
    angle = direction.screenAngle();

    add(spec.hitbox(size));
    add(BlurBulletSprite(this));

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

class BlurBulletSprite extends SpriteComponent {
  final Bullet bullet;

  BlurBulletSprite(this.bullet);

  @override
  Future onLoad() async {
    sprite = await getSprite(bullet.spec.spriteBlur);
    position = bullet.size / 2;
    width = sprite!.image.width * bullet.spriteRatio;
    height = sprite!.image.height * bullet.spriteRatio;
    anchor = Anchor.center;

    return super.onLoad();
  }
}
