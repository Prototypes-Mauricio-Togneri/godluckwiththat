import 'package:tensionnode/models/resources.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/types/turret_type.dart';

enum NodeType {
  headquarters(
    path: Assets.IMAGES_HQ,
  ),
  mine_red(
    path: Assets.IMAGES_MINE_RED,
    costRed: 100,
    costGreen: 0,
    costBlue: 0,
  ),
  mine_green(
    path: Assets.IMAGES_MINE_GREEN,
    costRed: 200,
    costGreen: 0,
    costBlue: 0,
  ),
  mine_blue(
    path: Assets.IMAGES_MINE_BLUE,
    costRed: 300,
    costGreen: 0,
    costBlue: 0,
  ),
  turret_light(
    path: Assets.IMAGES_TURRET_LIGHT,
    costRed: 500,
    costGreen: 0,
    costBlue: 0,
  );

  final String path;
  final int costRed;
  final int costGreen;
  final int costBlue;

  bool get isHeadquarters => this == headquarters;

  bool get isMine =>
      (this == mine_red) || (this == mine_green) || (this == mine_blue);

  bool get isTurret => this == turret_light;

  Resources get cost => Resources(
        red: costRed,
        green: costGreen,
        blue: costBlue,
      );

  ResourceType? get resource {
    if (this == mine_red) {
      return ResourceType.red;
    } else if (this == mine_green) {
      return ResourceType.green;
    } else if (this == mine_blue) {
      return ResourceType.blue;
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
    required this.path,
    this.costRed = 0,
    this.costGreen = 0,
    this.costBlue = 0,
  });
}
