import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/types/turret_type.dart';

enum NodeType {
  headquarters(Assets.IMAGES_HQ),
  mine_red(Assets.IMAGES_MINE_RED),
  mine_green(Assets.IMAGES_MINE_GREEN),
  mine_blue(Assets.IMAGES_MINE_BLUE),
  turret_light(Assets.IMAGES_TURRET_LIGHT);

  final String path;

  bool get isHeadquarters => this == headquarters;

  bool get isMine =>
      (this == mine_red) || (this == mine_green) || (this == mine_blue);

  bool get isTurret => this == turret_light;

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

  const NodeType(this.path);
}
