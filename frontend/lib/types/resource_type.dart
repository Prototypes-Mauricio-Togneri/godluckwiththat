import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(Palette.resource_red),
  green(Palette.resource_green),
  blue(Palette.resource_blue);

  final Color color;

  const ResourceType(this.color);

  String pathMine() {
    switch (this) {
      case ResourceType.red:
        return 'mine_red.png';
      case ResourceType.green:
        return 'mine_green.png';
      case ResourceType.blue:
        return 'mine_blue.png';
    }
  }

  String pathPatch() {
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
