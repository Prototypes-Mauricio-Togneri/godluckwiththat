import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/movable_node.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_enemy.dart';
import 'package:tensionnode/models/position.dart';
import 'package:tensionnode/models/shooting.dart';
import 'package:tensionnode/spec/enemy_spec.dart';

class Enemy extends MovableNode {
  final EnemySpec spec;
  final Shooting shooting;
  final double speed;
  final double range;
  final Vector2 kernelPosition;
  Node? target;
  bool _isRotating = false;

  Enemy({
    required super.position,
    required super.shield,
    required this.spec,
    required this.kernelPosition,
  })  : shooting = Shooting(spec.weapon.fireRate),
        speed = spec.speed * Constants.NODE_SIZE,
        range = spec.weapon.range * Constants.NODE_SIZE,
        super(
          type: spec.type,
          armor: spec.armor,
        );

  @override
  void update(double dt) {
    super.update(dt);
    shooting.update(dt);

    if ((target != null) && (!target!.isAlive)) {
      target = null;
    }

    target ??= game.closestNodeInRange<FixedNode>(this, range);

    if (target == null) {
      _moveForward(dt);
    } else {
      _rotateTo(target!.position);

      if (shooting.canShoot(dt)) {
        shoot(
          spec: spec.weapon,
          target: target!,
          weaponRange: range,
        );
      }
    }
  }

  void _rotateTo(Vector2 targetPosition) {
    if (!_isRotating) {
      final Vector2 direction = position - targetPosition;
      final double newAngle = direction.screenAngle() + pi;
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
    final Vector2 direction = (kernelPosition - position).normalized();
    position += direction * speed * dt;

    _rotateTo(direction);
  }

  JsonEnemy get json => JsonEnemy(
        type: type,
        position: Position.json(position),
        shield: shield.toInt(),
      );
}
