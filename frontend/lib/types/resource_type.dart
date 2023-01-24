import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(Palette.resource_red, 1),
  green(Palette.resource_green, 2),
  blue(Palette.resource_blue, 3);

  final Color color;
  final int productionTime;

  const ResourceType(this.color, this.productionTime);

  String get pathMine {
    switch (this) {
      case ResourceType.red:
        return Assets.IMAGES_MINE_RED;
      case ResourceType.green:
        return Assets.IMAGES_MINE_GREEN;
      case ResourceType.blue:
        return Assets.IMAGES_MINE_BLUE;
    }
  }

  String get pathPatch {
    switch (this) {
      case ResourceType.red:
        return Assets.IMAGES_PATCH_RED;
      case ResourceType.green:
        return Assets.IMAGES_PATCH_GREEN;
      case ResourceType.blue:
        return Assets.IMAGES_PATCH_BLUE;
    }
  }
}
