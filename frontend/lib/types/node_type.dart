import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/mine_type.dart';
import 'package:tensionnode/types/turret_type.dart';

enum NodeType {
  kernel(
    image: Assets.IMAGES_KERNEL,
    armor: 50,
  ),
  mine_red(
    image: Assets.IMAGES_MINE_RED,
    armor: 20,
    costRed: 10,
    costGreen: 0,
    costBlue: 0,
  ),
  mine_green(
    image: Assets.IMAGES_MINE_GREEN,
    armor: 20,
    costRed: 20,
    costGreen: 0,
    costBlue: 0,
  ),
  mine_blue(
    image: Assets.IMAGES_MINE_BLUE,
    armor: 20,
    costRed: 30,
    costGreen: 0,
    costBlue: 0,
  ),
  turret_light(
    image: Assets.IMAGES_TURRET_LIGHT,
    armor: 50,
    costRed: 50,
    costGreen: 0,
    costBlue: 0,
  );

  final String image;
  final double armor;
  final int costRed;
  final int costGreen;
  final int costBlue;

  bool get isKernel => this == kernel;

  bool get isMine => mine != null;

  bool get isTurret => turret != null;

  Resources get cost => Resources(
        red: costRed,
        green: costGreen,
        blue: costBlue,
      );

  MineType? get mine {
    if (this == mine_red) {
      return MineType.red;
    } else if (this == mine_green) {
      return MineType.green;
    } else if (this == mine_blue) {
      return MineType.blue;
    } else {
      return null;
    }
  }

  TurretType? get turret {
    if (this == turret_light) {
      return TurretType.light;
    } else {
      return null;
    }
  }

  const NodeType({
    required this.image,
    required this.armor,
    this.costRed = 0,
    this.costGreen = 0,
    this.costBlue = 0,
  });
}
