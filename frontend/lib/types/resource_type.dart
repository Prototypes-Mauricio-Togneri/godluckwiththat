import 'package:flutter/widgets.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/palette.dart';

enum ResourceType {
  red(
    color: Palette.resource_red,
    spriteBase: Assets.IMAGES_PATCH_RED_BASE,
    spriteBlur: Assets.IMAGES_PATCH_RED_BLUR,
  ),
  green(
    color: Palette.resource_green,
    spriteBase: Assets.IMAGES_PATCH_GREEN_BASE,
    spriteBlur: Assets.IMAGES_PATCH_GREEN_BLUR,
  ),
  blue(
    color: Palette.resource_blue,
    spriteBase: Assets.IMAGES_PATCH_BLUE_BASE,
    spriteBlur: Assets.IMAGES_PATCH_BLUE_BLUR,
  );

  final Color color;
  final String spriteBase;
  final String spriteBlur;

  const ResourceType({
    required this.color,
    required this.spriteBase,
    required this.spriteBlur,
  });
}
