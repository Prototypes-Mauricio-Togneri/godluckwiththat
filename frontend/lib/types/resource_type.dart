import 'package:tensionnode/services/assets.dart';

typedef Resources = List<ResourceType>;

enum ResourceType {
  timber(sprite: Assets.IMAGES_RESOURCES_TIMBER),
  wood(sprite: Assets.IMAGES_RESOURCES_WOOD),
  stone(sprite: Assets.IMAGES_RESOURCES_STONE),
  water(sprite: Assets.IMAGES_RESOURCES_WATER),
  fish(sprite: Assets.IMAGES_RESOURCES_FISH),
  meat(sprite: Assets.IMAGES_RESOURCES_MEAT),
  grain(sprite: Assets.IMAGES_RESOURCES_GRAIN),
  flour(sprite: Assets.IMAGES_RESOURCES_FLOUR),
  bread(sprite: Assets.IMAGES_RESOURCES_BREAD);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name;
}
