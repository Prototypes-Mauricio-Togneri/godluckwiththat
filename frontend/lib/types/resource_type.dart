import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(
    color: Palette.resource_red,
    path: Assets.IMAGES_PATCH_RED,
  ),
  green(
    color: Palette.resource_green,
    path: Assets.IMAGES_PATCH_GREEN,
  ),
  blue(
    color: Palette.resource_blue,
    path: Assets.IMAGES_PATCH_BLUE,
  );

  final Color color;
  final String path;

  const ResourceType({
    required this.color,
    required this.path,
  });
}
