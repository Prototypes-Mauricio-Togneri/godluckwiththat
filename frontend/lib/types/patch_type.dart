import 'package:godluckwiththat/types/building_type.dart';
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

  BuildingType get buildingType {
    switch (this) {
      case PatchType.water:
        return BuildingType.well;
      case PatchType.food:
        return BuildingType.farm;
      case PatchType.wood:
        return BuildingType.woodcutter;
      case PatchType.stone:
        return BuildingType.quarry;
    }
  }

  @override
  String toString() => name.replaceAll('_', ' ');
}
