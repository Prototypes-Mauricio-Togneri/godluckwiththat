import 'package:tensionplanet/utils/assets.dart';

enum ResourceType {
  food(sprite: Assets.IMAGES_RESOURCES_RESOURCES_IRON_ORE),
  wood(sprite: Assets.IMAGES_RESOURCES_RESOURCES_COPPER_ORE),
  stone(sprite: Assets.IMAGES_RESOURCES_RESOURCES_STONE_ORE),
  copper(sprite: Assets.IMAGES_RESOURCES_RESOURCES_WATER),
  iron(sprite: Assets.IMAGES_RESOURCES_RESOURCES_COAL_ORE),
  gold(sprite: Assets.IMAGES_RESOURCES_RESOURCES_URANIUM_ORE);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
