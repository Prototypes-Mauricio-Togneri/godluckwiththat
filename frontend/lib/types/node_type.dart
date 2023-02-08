import 'package:flame/collisions.dart';
import 'package:tensionnode/services/assets.dart';
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
  enemy(
    spriteBase: Assets.IMAGES_ENEMY_BASE,
    spriteBlur: Assets.IMAGES_ENEMY_BLUR,
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
      case NodeType.enemy:
        return EnemySpec.enemy;
    }
  }

  /*PolygonHitbox.relative(
    [
      Vector2(1, 0),
      Vector2(0, -1),
      Vector2(-1, 0),
      Vector2(0, 1),
    ],
    parentSize: size,
  )*/
  ShapeHitbox get hitbox {
    switch (this) {
      case NodeType.kernel:
        return CircleHitbox(isSolid: true);
      case NodeType.mine_red:
        return CircleHitbox(isSolid: true);
      case NodeType.mine_green:
        return CircleHitbox(isSolid: true);
      case NodeType.mine_blue:
        return CircleHitbox(isSolid: true);
      case NodeType.turret_light:
        return CircleHitbox(isSolid: true);
      case NodeType.enemy:
        return CircleHitbox(isSolid: true);
    }
  }
}
