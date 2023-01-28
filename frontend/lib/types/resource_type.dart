import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(
    color: Palette.resource_red,
    pathMine: Assets.IMAGES_MINE_RED,
    pathPatch: Assets.IMAGES_PATCH_RED,
    productionTime: 1,
  ),
  green(
    color: Palette.resource_green,
    pathMine: Assets.IMAGES_MINE_GREEN,
    pathPatch: Assets.IMAGES_PATCH_GREEN,
    productionTime: 2,
  ),
  blue(
    color: Palette.resource_blue,
    pathMine: Assets.IMAGES_MINE_BLUE,
    pathPatch: Assets.IMAGES_PATCH_BLUE,
    productionTime: 3,
  );

  final Color color;
  final String pathMine;
  final String pathPatch;
  final int productionTime;

  const ResourceType({
    required this.color,
    required this.pathMine,
    required this.pathPatch,
    required this.productionTime,
  });
}
