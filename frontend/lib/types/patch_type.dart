import 'package:tensionplanet/utils/assets.dart';

enum PatchType {
  iron(sprite: Assets.IMAGES_PATCHES_IRON_PATCH),
  copper(sprite: Assets.IMAGES_PATCHES_COPPER_PATCH),
  stone(sprite: Assets.IMAGES_PATCHES_STONE_PATCH),
  water(sprite: Assets.IMAGES_PATCHES_WATER_PATCH),
  coal(sprite: Assets.IMAGES_PATCHES_COAL_PATCH),
  oil(sprite: Assets.IMAGES_PATCHES_OIL_PATCH),
  titanium(sprite: Assets.IMAGES_PATCHES_TITANIUM_PATCH),
  uranium(sprite: Assets.IMAGES_PATCHES_URANIUM_PATCH);

  final String sprite;

  const PatchType({
    required this.sprite,
  });
}
