import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(
    color: Palette.resource_red,
    sprite: Assets.IMAGES_PATCH_RED,
  ),
  green(
    color: Palette.resource_green,
    sprite: Assets.IMAGES_PATCH_GREEN,
  ),
  blue(
    color: Palette.resource_blue,
    sprite: Assets.IMAGES_PATCH_BLUE,
  );

  final Color color;
  final String sprite;

  const ResourceType({
    required this.color,
    required this.sprite,
  });
}
