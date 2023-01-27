import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/types/resource_type.dart';

enum NodeType {
  headquarters(Assets.IMAGES_HQ),
  mine_red(Assets.IMAGES_MINE_RED),
  mine_green(Assets.IMAGES_MINE_GREEN),
  mine_blue(Assets.IMAGES_MINE_BLUE);

  final String path;

  const NodeType(this.path);

  bool get isMine =>
      (this == mine_red) || (this == mine_green) || (this == mine_blue);

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
}
