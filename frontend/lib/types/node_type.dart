import 'package:tensionnode/services/assets.dart';

enum NodeType {
  headquarters(Assets.IMAGES_HQ),
  mine_red(Assets.IMAGES_MINE_RED),
  mine_green(Assets.IMAGES_MINE_GREEN),
  mine_blue(Assets.IMAGES_MINE_BLUE);

  final String path;

  const NodeType(this.path);

  bool get isMine =>
      (this == mine_red) || (this == mine_green) || (this == mine_blue);
}
