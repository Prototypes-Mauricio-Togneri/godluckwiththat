import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/utils/assets.dart';

enum PatchType {
  empty(
    sprite: Assets.IMAGES_PATCHES_EMPTY,
    resourceType: ResourceType.villager,
  ),
  crop_field(
    sprite: Assets.IMAGES_PATCHES_CROP_FIELD,
    resourceType: ResourceType.food,
  ),
  forest(
    sprite: Assets.IMAGES_PATCHES_FOREST,
    resourceType: ResourceType.wood,
  ),
  stone_deposit(
    sprite: Assets.IMAGES_PATCHES_STONE_DEPOSIT,
    resourceType: ResourceType.stone,
  );
  //copper_deposit(sprite: Assets.IMAGES_RESOURCES_COPPER),
  //iron_deposit(sprite: Assets.IMAGES_RESOURCES_IRON),
  //gold_deposit(sprite: Assets.IMAGES_RESOURCES_GOLD);

  final String sprite;
  final ResourceType resourceType;

  const PatchType({
    required this.sprite,
    required this.resourceType,
  });

  bool allowsBuildingType(BuildingType buildingType) {
    switch (buildingType) {
      case BuildingType.headquarters:
        return false;
      case BuildingType.farm:
        return this == crop_field;
      case BuildingType.woodcutter:
        return this == forest;
      case BuildingType.quarry:
        return this == stone_deposit;
      case BuildingType.copper_mine:
        return false; // TODO(momo): update
      case BuildingType.iron_mine:
        return false; // TODO(momo): update
      case BuildingType.gold_mine:
        return false; // TODO(momo): update
      case BuildingType.house:
      case BuildingType.warehouse:
      case BuildingType.barracks:
      case BuildingType.archery:
      case BuildingType.cavalry:
      case BuildingType.workshop:
      case BuildingType.fortress:
        return this == empty;
    }
  }

  @override
  String toString() => name.replaceAll('_', ' ');
}
