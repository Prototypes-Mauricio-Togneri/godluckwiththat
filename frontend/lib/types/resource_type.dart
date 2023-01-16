import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(Palette.resource_red, 1),
  green(Palette.resource_green, 2),
  blue(Palette.resource_blue, 3);

  final Color color;
  final int productionType;

  const ResourceType(this.color, this.productionType);

  String get pathMine {
    switch (this) {
      case ResourceType.red:
        return 'mine_red.png';
      case ResourceType.green:
        return 'mine_green.png';
      case ResourceType.blue:
        return 'mine_blue.png';
    }
  }

  String get pathPatch {
    switch (this) {
      case ResourceType.red:
        return 'patch_red.png';
      case ResourceType.green:
        return 'patch_green.png';
      case ResourceType.blue:
        return 'patch_blue.png';
    }
  }
}
