import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/collisionable.dart';
import 'package:tensionnode/spec/enemy_spec.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';
import 'package:tensionnode/spec/mine_spec.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/turret_spec.dart';

enum NodeType {
  kernel(
    sprite: Assets.IMAGES_KERNEL,
  ),
  mine_red(
    sprite: Assets.IMAGES_MINE,
  ),
  mine_green(
    sprite: Assets.IMAGES_MINE,
  ),
  mine_blue(
    sprite: Assets.IMAGES_MINE,
  ),
  turret_light(
    sprite: Assets.IMAGES_TURRET_LIGHT,
  ),
  turret_heavy(
    sprite: Assets.IMAGES_TURRET_HEAVY,
  ),
  turret_machine_gun(
    sprite: Assets.IMAGES_TURRET_MACHINE_GUN,
  ),
  enemy1(
    sprite: Assets.IMAGES_ENEMY,
  ),
  enemy2(
    sprite: Assets.IMAGES_ENEMY,
  ),
  enemy3(
    sprite: Assets.IMAGES_ENEMY,
  );

  final String sprite;

  const NodeType({
    required this.sprite,
  });

  bool get isKernel => this == kernel;

  bool get isMine =>
      (this == mine_red) || (this == mine_green) || (this == mine_blue);

  bool get isTurret => this == turret_light;

  NodeSpec get spec {
    switch (this) {
      case NodeType.kernel:
        return FixedNodeSpec.kernel;
      case NodeType.mine_red:
        return MineSpec.mine_red;
      case NodeType.mine_green:
        return MineSpec.mine_green;
      case NodeType.mine_blue:
        return MineSpec.mine_blue;
      case NodeType.turret_light:
        return TurretSpec.turret_light;
      case NodeType.turret_heavy:
        return TurretSpec.turret_heavy;
      case NodeType.turret_machine_gun:
        return TurretSpec.turret_machine_gun;
      case NodeType.enemy1:
        return EnemySpec.enemy1;
      case NodeType.enemy2:
        return EnemySpec.enemy2;
      case NodeType.enemy3:
        return EnemySpec.enemy3;
    }
  }

  ShapeHitbox hitbox(Vector2 parentSize) {
    switch (this) {
      case NodeType.kernel:
        return Collisionable.polygon(
          parentSize: parentSize,
          points: [
            Vector2(0, -1),
            Vector2(1, 0),
            Vector2(0, 1),
            Vector2(-1, 0),
          ],
        );
      case NodeType.mine_red:
      case NodeType.mine_green:
      case NodeType.mine_blue:
        return Collisionable.square(parentSize);
      case NodeType.turret_light:
      case NodeType.turret_heavy:
      case NodeType.turret_machine_gun:
        return Collisionable.circle(parentSize);
      case NodeType.enemy1:
      case NodeType.enemy2:
      case NodeType.enemy3:
        return Collisionable.circle(parentSize);
    }
  }
}
