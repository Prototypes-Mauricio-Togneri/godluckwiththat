import 'package:tensionnode/services/assets.dart';

enum NodeType {
  headquarters(Assets.IMAGES_HQ),
  mine(Assets.IMAGES_MINE_RED);

  final String path;

  const NodeType(this.path);
}
