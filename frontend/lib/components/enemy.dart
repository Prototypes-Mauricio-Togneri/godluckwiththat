import 'dart:math';
import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/fixed_node.dart';
import 'package:tensionnode/components/movable_node.dart';
import 'package:tensionnode/components/node.dart';
import 'package:tensionnode/models/shooting.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/direction.dart';

class Enemy extends MovableNode {
  final Direction direction;
  final double speed;
  final double range;
  final double damage;
  final Shooting shooting = Shooting(1); // TODO(momo): change fire rate
  Node? target;

  Enemy({
    required super.position,
    required this.direction,
    required this.speed,
    required this.range,
    required this.damage,
  }) : super(path: Assets.IMAGES_ENEMY);

  @override
  void update(double dt) {
    super.update(dt);

    if ((target != null) && (!target!.isAlive)) {
      target = null;
    }

    target ??= game.closestNodeInRange<FixedNode>(this, range);

    if (target == null) {
      _moveForward(dt);
      // TODO(momo): if passed the outer most node, remove the enemy
    } else {
      final Vector2 vector = target!.position - position;
      angle = -atan2(vector.y, vector.x) * 180 / pi;
      print(position);
      print(target!.position);
      print(angle);
      print('---------');

      if (shooting.canShoot(dt)) {
        final Vector2 direction = (target!.position - position).normalized();
        final Vector2 originalPosition =
            position + (direction * (Constants.NODE_SIZE / 2));

        game.addBullet(
          position: originalPosition,
          direction: direction,
          range: range * 1.5,
          damage: damage,
        );
      }
    }
  }

  void _moveForward(double dt) {
    angle = 0;

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
