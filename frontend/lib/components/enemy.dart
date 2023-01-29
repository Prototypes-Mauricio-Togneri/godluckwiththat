import 'dart:async';
import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/node.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/shooting.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/direction.dart';

class Enemy extends SpriteComponent with HasGameRef<GameComponent> {
  final int i;
  final int j;
  final Direction direction;
  final double speed;
  final double range;
  final Shooting shooting = Shooting(1);
  Node? target;

  Enemy({
    required this.i,
    required this.j,
    required this.direction,
    required this.speed,
    required this.range,
  });

  @override
  FutureOr onLoad() async {
    position = Vector2(
      i * Constants.NODE_SIZE,
      j * Constants.NODE_SIZE,
    );
    sprite = await getSprite(Assets.IMAGES_ENEMY);
    width = Constants.NODE_SIZE;
    height = Constants.NODE_SIZE;
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if ((target != null) && (!target!.isAlive)) {
      target = null;
    }

    target ??= game.closestNodeInRange(this, range);

    if (target == null) {
      _moveForward(dt);
    } else if (shooting.canShoot(dt)) {
      game.addBullet(
        position: position,
        target: target!.position,
        speed: 100,
      );
    }
  }

  void _moveForward(double dt) {
    switch (direction) {
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
    }
  }
}
