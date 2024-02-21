import 'package:godluckwiththat/utils/assets.dart';

enum ResourceType {
  food(sprite: Assets.IMAGES_RESOURCES_FOOD),
  wood(sprite: Assets.IMAGES_RESOURCES_WOOD),
  stone(sprite: Assets.IMAGES_RESOURCES_STONE);

  final String sprite;

  const ResourceType({
    required this.sprite,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
