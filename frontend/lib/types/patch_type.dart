import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';

enum PatchType {
  water(
    sprite: Assets.IMAGES_PATCHES_WATER,
    resourceType: ResourceType.water,
  ),
  food(
    sprite: Assets.IMAGES_PATCHES_FOOD,
    resourceType: ResourceType.food,
  ),
  wood(
    sprite: Assets.IMAGES_PATCHES_WOOD,
    resourceType: ResourceType.wood,
  ),
  stone(
    sprite: Assets.IMAGES_PATCHES_STONE,
    resourceType: ResourceType.stone,
  );

  final String sprite;
  final ResourceType resourceType;

  const PatchType({
    required this.sprite,
    required this.resourceType,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
