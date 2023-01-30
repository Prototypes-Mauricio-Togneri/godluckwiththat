import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/movable_node.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/shooting.dart';
import 'package:tensionnode/spec/enemy_spec.dart';
import 'package:tensionnode/types/direction.dart';

class Enemy extends MovableNode {
  final EnemySpec spec;
  final Direction direction;
  final Shooting shooting;
  Node? target;
  bool _isRotating = false;

  Enemy({
    required super.position,
    required super.shield,
    required this.spec,
    required this.direction,
  })  : shooting = Shooting(spec.weapon.fireRate),
        super(
          image: spec.type.image,
          armor: spec.armor,
        );

  @override
  Future onLoad() {
    nativeAngle = pi / 2;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    shooting.update(dt);

    if ((target != null) && (!target!.isAlive)) {
      target = null;
    }

    target ??= game.closestNodeInRange<FixedNode>(this, spec.weapon.range);

    if (target == null) {
      _moveForward(dt);
      // TODO(momo): if passed the outer most node, remove the enemy
    } else {
      _rotateTo(target!.position);

      if (shooting.canShoot(dt)) {
        shoot(
          spec: spec.weapon,
          target: target!,
        );
      }
    }
  }

  void _rotateTo(Vector2 targetPosition) {
    if (!_isRotating) {
      final Vector2 direction = position - targetPosition;
      final double newAngle = direction.screenAngle() + (pi / 2);
      final double angleDiff = (angle - newAngle).abs();

      if (angleDiff > 0.01) {
        _isRotating = true;
        add(
          RotateEffect.to(
            newAngle,
            LinearEffectController(0.2),
            onComplete: () {
              _isRotating = false;
            },
          ),
        );
      }
    }
  }

  void _moveForward(double dt) {
    _rotateTo(position + direction.vector);

    switch (direction) {
      case Direction.up:
        y -= dt * spec.speed;
        break;
      case Direction.down:
        y += dt * spec.speed;
        break;
      case Direction.left:
        x -= dt * spec.speed;
        break;
      case Direction.right:
        x += dt * spec.speed;
        break;
    }
  }
}
