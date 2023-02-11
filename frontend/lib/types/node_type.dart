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
    spriteBase: Assets.IMAGES_KERNEL_BASE,
    spriteBlur: Assets.IMAGES_KERNEL_BLUR,
  ),
  mine_red(
    spriteBase: Assets.IMAGES_MINE_BASE,
    spriteBlur: Assets.IMAGES_MINE_RED_BLUR,
  ),
  mine_green(
    spriteBase: Assets.IMAGES_MINE_BASE,
    spriteBlur: Assets.IMAGES_MINE_GREEN_BLUR,
  ),
  mine_blue(
    spriteBase: Assets.IMAGES_MINE_BASE,
    spriteBlur: Assets.IMAGES_MINE_BLUE_BLUR,
  ),
  turret_light(
    spriteBase: Assets.IMAGES_TURRET_LIGHT_BASE,
    spriteBlur: Assets.IMAGES_TURRET_LIGHT_BLUR,
  ),
  turret_heavy(
    spriteBase: Assets.IMAGES_TURRET_HEAVY_BASE,
    spriteBlur: Assets.IMAGES_TURRET_HEAVY_BLUR,
  ),
  turret_machine_gun(
    spriteBase: Assets.IMAGES_TURRET_MACHINE_GUN_BASE,
    spriteBlur: Assets.IMAGES_TURRET_MACHINE_GUN_BLUR,
  ),
  enemy1(
    spriteBase: Assets.IMAGES_ENEMY_1_BASE,
    spriteBlur: Assets.IMAGES_ENEMY_1_BLUR,
  ),
  enemy2(
    spriteBase: Assets.IMAGES_ENEMY_2_BASE,
    spriteBlur: Assets.IMAGES_ENEMY_2_BLUR,
  ),
  enemy3(
    spriteBase: Assets.IMAGES_ENEMY_3_BASE,
    spriteBlur: Assets.IMAGES_ENEMY_3_BLUR,
  );

  final String spriteBase;
  final String spriteBlur;

  const NodeType({
    required this.spriteBase,
    required this.spriteBlur,
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
        return Collisionable.polygon(
          parentSize: parentSize,
          points: [
            Vector2(0, -1),
            Vector2(1, 1),
            Vector2(-1, 1),
          ],
        );
      case NodeType.enemy2:
        return Collisionable.polygon(
          parentSize: parentSize,
          points: [
            Vector2(0, -1),
            Vector2(1, 0.35),
            Vector2(0, 1),
            Vector2(-1, 0.35),
          ],
        );
      case NodeType.enemy3: // TODO(momo): adjust
        return Collisionable.polygon(
          parentSize: parentSize,
          points: [
            Vector2(0, -1),
            Vector2(1, 1),
            Vector2(-1, 1),
          ],
        );
    }
  }
}
