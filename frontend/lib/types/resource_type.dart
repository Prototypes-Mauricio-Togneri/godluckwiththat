import 'package:tensionplanet/utils/assets.dart';

enum ResourceType {
  food(sprite: Assets.IMAGES_RESOURCES_FOOD),
  wood(sprite: Assets.IMAGES_RESOURCES_WOOD),
  stone(sprite: Assets.IMAGES_RESOURCES_STONE),
  copper(sprite: Assets.IMAGES_RESOURCES_COPPER),
  iron(sprite: Assets.IMAGES_RESOURCES_IRON),
  gold(sprite: Assets.IMAGES_RESOURCES_GOLD),
  villager(sprite: Assets.IMAGES_RESOURCES_VILLAGER);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
