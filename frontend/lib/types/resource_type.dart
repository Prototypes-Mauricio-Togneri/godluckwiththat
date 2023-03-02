import 'package:tensionnode/services/assets.dart';

enum ResourceType {
  energy(sprite: Assets.IMAGES_RESOURCES_ENERGY),
  iron_ore(sprite: Assets.IMAGES_RESOURCES_IRON_ORE),
  copper_ore(sprite: Assets.IMAGES_RESOURCES_COPPER_ORE),
  coal_ore(sprite: Assets.IMAGES_RESOURCES_COAL_ORE),
  stone_ore(sprite: Assets.IMAGES_RESOURCES_STONE_ORE),
  iron_block(
      sprite:
          Assets.IMAGES_RESOURCES_COPPER_BLOCK), // TODO(momo): replace sprite
  copper_block(sprite: Assets.IMAGES_RESOURCES_COPPER_BLOCK),
  steel(
      sprite:
          Assets.IMAGES_RESOURCES_COPPER_BLOCK), // TODO(momo): replace sprite
  concrete(
      sprite:
          Assets.IMAGES_RESOURCES_COPPER_BLOCK); // TODO(momo): replace sprite

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name;
}
