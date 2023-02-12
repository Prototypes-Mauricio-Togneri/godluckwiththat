import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/movable_node.dart';
import 'package:tensionnode/extensions/num_extension.dart';
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
  //Node? _target;

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

  /*@override
  void update(double dt) {
    super.update(dt);
    shooting.update(dt);

    if ((_target != null) && (!_target!.isAlive)) {
      _target = null;
    }

    _target ??= game.state.closestTurretInRange(this, range);

    if (_target == null) {
      _moveForward(dt);
    } else {
      rotateTo(_target!.position);

      if (shooting.canShoot(dt)) {
        shoot(
          spec: spec.weapon,
          target: _target!,
          weaponRange: range,
        );
      }
    }
  }*/

  /*void _moveForward(double dt) {
    final Vector2 direction = (kernelPosition - position).normalized();
    position += direction * speed * dt;

    rotateTo(direction);
  }*/

  JsonEnemy get json => JsonEnemy(
        type: type,
        position: Position.json(position),
        shield: shield.decimal(),
      );
}
