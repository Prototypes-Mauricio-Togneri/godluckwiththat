import 'package:flame/input.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/num_extension.dart';
import 'package:tensionnode/json/json_turret.dart';
import 'package:tensionnode/models/shooting.dart';
import 'package:tensionnode/spec/turret_spec.dart';

class Turret extends FixedNode {
  final TurretSpec spec;
  final Shooting shooting;
  final double range;
  int shotsFired;
  int kills;
  Node? _target;

  Turret({
    required super.i,
    required super.j,
    required super.health,
    required this.shotsFired,
    required this.kills,
    required this.spec,
  })  : shooting = Shooting(spec.weapon.fireRate),
        range = spec.weapon.range * Constants.NODE_SIZE,
        super(type: spec.type);

  @override
  void update(double dt) {
    super.update(dt);
    shooting.update(dt);

    final bool isTargetDestroyed = (_target != null) && (!_target!.isAlive);
    final bool isTargetOutOfRange =
        (_target != null) && _target!.distance(this) > range;

    if (isTargetDestroyed || isTargetOutOfRange) {
      _target = null;
    }

    _target ??= game.state.closestEnemyInRange(this, range);

    if ((_target != null) && shooting.canShoot(dt)) {
      shotsFired++;

      rotateTo(_target!.position);
      shoot(
        spec: spec.weapon,
        target: _target!,
        weaponRange: range,
      );
    }
  }

  @override
  bool onTapUp(TapUpInfo info) => game.selectNode(this);

  JsonTurret get json => JsonTurret(
        type: type,
        position: [i, j],
        health: health.decimal(),
        shotsFired: shotsFired,
        kills: kills,
      );
}
