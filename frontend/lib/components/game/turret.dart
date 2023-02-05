import 'package:flame/input.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/movable_node.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/shooting.dart';
import 'package:tensionnode/spec/turret_spec.dart';

class Turret extends FixedNode {
  final TurretSpec spec;
  final Shooting shooting;
  final double range;
  Node? target;

  Turret({
    required super.i,
    required super.j,
    required super.shield,
    required this.spec,
  })  : shooting = Shooting(spec.weapon.fireRate),
        range = spec.weapon.range * Constants.NODE_SIZE,
        super(
          type: spec.type,
          armor: spec.armor,
          heat: spec.heat,
        );

  @override
  void update(double dt) {
    super.update(dt);
    shooting.update(dt);

    final bool isTargetDestroyed = (target != null) && (!target!.isAlive);
    final bool isTargetOutOfRange =
        (target != null) && target!.distance(this) > range;

    if (isTargetDestroyed || isTargetOutOfRange) {
      target = null;
    }

    target ??= game.closestNodeInRange<MovableNode>(this, range);

    if ((target != null) && shooting.canShoot(dt)) {
      shoot(
        spec: spec.weapon,
        target: target!,
        weaponRange: range,
      );
    }
  }

  @override
  bool onTapUp(TapUpInfo info) => game.onNodeSelected(this);
}
