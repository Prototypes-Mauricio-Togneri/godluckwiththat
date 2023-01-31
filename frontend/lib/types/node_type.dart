import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/spec/enemy_spec.dart';
import 'package:tensionnode/spec/mine_spec.dart';
import 'package:tensionnode/spec/node_spec.dart';
import 'package:tensionnode/spec/turret_spec.dart';

enum NodeType {
  kernel(sprite: Assets.IMAGES_KERNEL),
  mine_red(sprite: Assets.IMAGES_MINE_RED),
  mine_green(sprite: Assets.IMAGES_MINE_GREEN),
  mine_blue(sprite: Assets.IMAGES_MINE_BLUE),
  turret_light(sprite: Assets.IMAGES_TURRET_LIGHT),
  enemy(sprite: Assets.IMAGES_ENEMY);

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
        return NodeSpec.kernel;
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
}
