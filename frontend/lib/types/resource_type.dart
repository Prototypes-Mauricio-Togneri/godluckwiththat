import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(
    Palette.resource_red,
    Assets.IMAGES_MINE_RED,
    Assets.IMAGES_PATCH_RED,
    1,
  ),
  green(
    Palette.resource_green,
    Assets.IMAGES_MINE_GREEN,
    Assets.IMAGES_PATCH_GREEN,
    2,
  ),
  blue(
    Palette.resource_blue,
    Assets.IMAGES_MINE_BLUE,
    Assets.IMAGES_PATCH_BLUE,
    3,
  );

  final Color color;
  final String pathMine;
  final String pathPatch;
  final int productionTime;

  const ResourceType(
    this.color,
    this.pathMine,
    this.pathPatch,
    this.productionTime,
  );
}
