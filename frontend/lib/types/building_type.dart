import 'package:tensionplanet/extensions/resource_map_extension.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/assets.dart';

enum BuildingType {
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_HEADQUARTERS,
    initialCost: {},
  ),
  house(
    sprite: Assets.IMAGES_BUILDINGS_HOUSE,
    initialCost: {
      ResourceType.wood: 2,
    },
  ),
  market(
    sprite: Assets.IMAGES_BUILDINGS_MARKET,
    initialCost: {
      ResourceType.wood: 10,
      ResourceType.stone: 10,
    },
  ),
  warehouse(
    sprite: Assets.IMAGES_BUILDINGS_WAREHOUSE,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
  ),

  farm(
    sprite: Assets.IMAGES_BUILDINGS_FARM,
    initialCost: {
      ResourceType.wood: 5,
    },
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_WOODCUTTER,
    initialCost: {
      ResourceType.wood: 5,
    },
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_QUARRY,
    initialCost: {
      ResourceType.wood: 5,
    },
  ),

  copper_mine(
    sprite: Assets.IMAGES_BUILDINGS_COPPER_MINE,
    initialCost: {
      ResourceType.wood: 5,
      ResourceType.stone: 5,
    },
  ),
  iron_mine(
    sprite: Assets.IMAGES_BUILDINGS_IRON_MINE,
    initialCost: {
      ResourceType.wood: 10,
      ResourceType.stone: 10,
    },
  ),
  gold_mine(
    sprite: Assets.IMAGES_BUILDINGS_GOLD_MINE,
    initialCost: {
      ResourceType.wood: 15,
      ResourceType.stone: 15,
    },
  ),

  tower(
    sprite: Assets.IMAGES_BUILDINGS_TOWER,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
  ),
  fortress(
    sprite: Assets.IMAGES_BUILDINGS_FORTRESS,
    initialCost: {
      ResourceType.wood: 50,
      ResourceType.stone: 50,
    },
  );

  final String sprite;
  final ResourceMap initialCost;

  const BuildingType({
    required this.sprite,
    required this.initialCost,
  });

  ResourceMap cost(int level) => {};

  @override
  String toString() => name.replaceAll('_', ' ');
}
