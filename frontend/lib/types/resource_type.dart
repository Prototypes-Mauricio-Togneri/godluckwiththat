import 'package:godluckwiththat/utils/assets.dart';

enum ResourceType {
  food(sprite: Assets.IMAGES_RESOURCES_FOOD),
  wood(sprite: Assets.IMAGES_RESOURCES_WOOD),
  stone(sprite: Assets.IMAGES_RESOURCES_STONE),
  copper(sprite: Assets.IMAGES_RESOURCES_COPPER),
  iron(sprite: Assets.IMAGES_RESOURCES_IRON),
  gold(sprite: Assets.IMAGES_RESOURCES_GOLD),
  faith(sprite: Assets.IMAGES_RESOURCES_FAITH),
  knowledge(sprite: Assets.IMAGES_RESOURCES_KNOWLEDGE);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
