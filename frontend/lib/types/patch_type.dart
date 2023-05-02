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
}
