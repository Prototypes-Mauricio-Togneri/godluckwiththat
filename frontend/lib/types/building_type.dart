import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';

enum BuildingType {
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_MISC_HEADQUARTERS,
    initialCost: {
      ResourceType.wood: 100,
    },
  ),
  house(
    sprite: Assets.IMAGES_BUILDINGS_MISC_HOUSE,
    initialCost: {
      ResourceType.wood: 50,
    },
  ),
  academy(
    sprite: Assets.IMAGES_BUILDINGS_MISC_ACADEMY,
    initialCost: {
      ResourceType.wood: 50,
    },
  ),
  storehouse(
    sprite: Assets.IMAGES_BUILDINGS_MISC_STOREHOUSE,
    initialCost: {
      ResourceType.wood: 50,
    },
  ),
  market(
    sprite: Assets.IMAGES_BUILDINGS_MISC_MARKET,
    initialCost: {
      ResourceType.wood: 50,
    },
  ),

  farm(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_FARM,
    initialCost: {
      ResourceType.wood: 50,
    },
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_WOODCUTTER,
    initialCost: {
      ResourceType.wood: 50,
    },
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_QUARRY,
    initialCost: {
      ResourceType.wood: 100,
    },
  ),
  copperMine(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_COPPER_MINE,
    initialCost: {
      ResourceType.wood: 100,
      ResourceType.stone: 50,
    },
  ),
  ironMine(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_IRON_MINE,
    initialCost: {
      ResourceType.wood: 100,
      ResourceType.stone: 50,
    },
  ),
  goldMine(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_GOLD_MINE,
    initialCost: {
      ResourceType.wood: 100,
      ResourceType.stone: 50,
    },
  ),

  altar(
    sprite: Assets.IMAGES_BUILDINGS_RELIGIOUS_ALTAR,
    initialCost: {
      ResourceType.wood: 100,
      ResourceType.stone: 50,
    },
  ),
  shrine(
    sprite: Assets.IMAGES_BUILDINGS_RELIGIOUS_SHRINE,
    initialCost: {
      ResourceType.wood: 100,
      ResourceType.stone: 50,
    },
  ),
  temple(
    sprite: Assets.IMAGES_BUILDINGS_RELIGIOUS_TEMPLE,
    initialCost: {
      ResourceType.wood: 100,
      ResourceType.stone: 50,
    },
  ),
  monument(
    sprite: Assets.IMAGES_BUILDINGS_RELIGIOUS_MONUMENT,
    initialCost: {
      ResourceType.wood: 100,
      ResourceType.stone: 50,
    },
  );

  final String sprite;
  final ResourceMap initialCost;

  const BuildingType({
    required this.sprite,
    required this.initialCost,
  });

  ResourceMap cost(int level) => initialCost.multiply(level);

  String get localized => name.replaceAll('_', ' ');
}
