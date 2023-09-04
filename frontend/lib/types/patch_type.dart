import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';

enum PatchType {
  food(
    sprite: Assets.IMAGES_PATCHES_FOOD,
    resourceType: ResourceType.food,
  ),
  wood(
    sprite: Assets.IMAGES_PATCHES_WOOD,
    resourceType: ResourceType.wood,
  ),
  water(
    sprite: Assets.IMAGES_PATCHES_WATER,
    resourceType: ResourceType.water,
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
      case PatchType.food:
        return BuildingType.farm;
      case PatchType.wood:
        return BuildingType.woodcutter;
      case PatchType.water:
        return BuildingType.well;
      case PatchType.stone:
        return BuildingType.quarry;
    }
  }

  String get patchesText {
    switch (this) {
      case PatchType.food:
        return 'Fields';
      case PatchType.wood:
        return 'Forest';
      case PatchType.water:
        return 'Water deposits';
      case PatchType.stone:
        return 'Stone deposits';
    }
  }

  @override
  String toString() => name.replaceAll('_', ' ');
}
