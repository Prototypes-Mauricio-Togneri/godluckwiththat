import 'package:godluckwiththat/utils/assets.dart';

enum ResourceType {
  water(sprite: Assets.IMAGES_RESOURCES_WATER),
  food(sprite: Assets.IMAGES_RESOURCES_FOOD),
  wood(sprite: Assets.IMAGES_RESOURCES_WOOD),
  stone(sprite: Assets.IMAGES_RESOURCES_STONE),
  villager(sprite: Assets.IMAGES_RESOURCES_VILLAGER);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
