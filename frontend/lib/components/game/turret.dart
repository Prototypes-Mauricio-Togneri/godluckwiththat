import 'package:flame/input.dart';
import 'package:tensionnode/components/base/fixed_node.dart';
import 'package:tensionnode/components/base/movable_node.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/dialog/contextual/turret_menu.dart';
import 'package:tensionnode/models/shooting.dart';
import 'package:tensionnode/spec/turret_spec.dart';

class Turret extends FixedNode {
  final TurretSpec spec;
  final Shooting shooting;
  Node? target;

  Turret({
    required super.i,
    required super.j,
    required super.shield,
    required this.spec,
  })  : shooting = Shooting(spec.weapon.fireRate),
        super(
          image: spec.type.sprite,
          armor: spec.armor,
        );

  @override
  void update(double dt) {
    super.update(dt);
    shooting.update(dt);

    if ((target != null) && (!target!.isAlive)) {
      target = null;
    }

    target ??= game.closestNodeInRange<MovableNode>(this, spec.weapon.range);

    if ((target != null) && shooting.canShoot(dt)) {
      shoot(
        spec: spec.weapon,
        target: target!,
      );
    }
  }

  @override
  bool onTapUp(TapUpInfo info) {
    if (game.state.deleteMode) {
      kill();
    } else {
      game.openMenu(
        name: TurretMenu.NAME,
        node: this,
      );
    }

    return true;
  }
}
