import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';

enum BuildingType {
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_MISC_HEADQUARTERS,
    initialCost: {
      ResourceType.wood: 10,
    },
  ),
  house(
    sprite: Assets.IMAGES_BUILDINGS_MISC_HOUSE,
    initialCost: {
      ResourceType.wood: 10,
    },
  ),
  academy(
    sprite: Assets.IMAGES_BUILDINGS_MISC_ACADEMY,
    initialCost: {
      ResourceType.wood: 20,
    },
  ),
  storehouse(
    sprite: Assets.IMAGES_BUILDINGS_MISC_STOREHOUSE,
    initialCost: {
      ResourceType.wood: 30,
    },
  ),
  market(
    sprite: Assets.IMAGES_BUILDINGS_MISC_MARKET,
    initialCost: {
      ResourceType.wood: 40,
    },
  ),

  farm(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_FARM,
    initialCost: {
      ResourceType.wood: 10,
    },
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_WOODCUTTER,
    initialCost: {
      ResourceType.wood: 10,
    },
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_QUARRY,
    initialCost: {
      ResourceType.wood: 20,
    },
  ),
  copperMine(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_COPPER_MINE,
    initialCost: {
      ResourceType.wood: 30,
      ResourceType.stone: 20,
    },
  ),
  ironMine(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_IRON_MINE,
    initialCost: {
      ResourceType.wood: 40,
      ResourceType.stone: 30,
    },
  ),
  goldMine(
    sprite: Assets.IMAGES_BUILDINGS_RESOURCES_GOLD_MINE,
    initialCost: {
      ResourceType.wood: 50,
      ResourceType.stone: 40,
    },
  ),

  altar(
    sprite: Assets.IMAGES_BUILDINGS_RELIGIOUS_ALTAR,
    initialCost: {
      ResourceType.wood: 30,
    },
  ),
  shrine(
    sprite: Assets.IMAGES_BUILDINGS_RELIGIOUS_SHRINE,
    initialCost: {
      ResourceType.wood: 40,
      ResourceType.stone: 20,
    },
  ),
  temple(
    sprite: Assets.IMAGES_BUILDINGS_RELIGIOUS_TEMPLE,
    initialCost: {
      ResourceType.wood: 50,
      ResourceType.stone: 40,
    },
  ),
  monument(
    sprite: Assets.IMAGES_BUILDINGS_RELIGIOUS_MONUMENT,
    initialCost: {
      ResourceType.wood: 60,
      ResourceType.stone: 60,
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

  String get description {
    const String text =
        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.';

    switch (this) {
      case BuildingType.headquarters:
        return text;
      case BuildingType.house:
        return text;
      case BuildingType.academy:
        return text;
      case BuildingType.storehouse:
        return text;
      case BuildingType.market:
        return text;
      case BuildingType.farm:
        return text;
      case BuildingType.woodcutter:
        return text;
      case BuildingType.quarry:
        return text;
      case BuildingType.copperMine:
        return text;
      case BuildingType.ironMine:
        return text;
      case BuildingType.goldMine:
        return text;
      case BuildingType.altar:
        return text;
      case BuildingType.shrine:
        return text;
      case BuildingType.temple:
        return text;
      case BuildingType.monument:
        return text;
    }
  }
}
