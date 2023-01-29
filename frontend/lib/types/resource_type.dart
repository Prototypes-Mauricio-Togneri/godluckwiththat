import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(
    color: Palette.resource_red,
    path: Assets.IMAGES_PATCH_RED,
    productionTime: 1,
  ),
  green(
    color: Palette.resource_green,
    path: Assets.IMAGES_PATCH_GREEN,
    productionTime: 2,
  ),
  blue(
    color: Palette.resource_blue,
    path: Assets.IMAGES_PATCH_BLUE,
    productionTime: 3,
  );

  final Color color;
  final String path;
  final int productionTime;

  const ResourceType({
    required this.color,
    required this.path,
    required this.productionTime,
  });
}
