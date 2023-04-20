import 'package:flame/extensions.dart';
import 'package:tensionplanet/extensions/resource_map_extension.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/assets.dart';

enum BuildingType {
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_HEADQUARTERS,
    initialCost: {},
    position: Offset(0.5, 0.5),
  ),
  house(
    sprite: Assets.IMAGES_BUILDINGS_HOUSE,
    initialCost: {
      ResourceType.wood: 2,
    },
    position: Offset(0.5, 0.32),
  ),
  market(
    sprite: Assets.IMAGES_BUILDINGS_MARKET,
    initialCost: {
      ResourceType.wood: 10,
      ResourceType.stone: 10,
    },
    position: Offset(0.66, 0.5),
  ),
  warehouse(
    sprite: Assets.IMAGES_BUILDINGS_WAREHOUSE,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.32, 0.5),
  ),

  farm(
    sprite: Assets.IMAGES_BUILDINGS_FARM,
    initialCost: {
      ResourceType.wood: 5,
    },
    position: Offset(0, 0),
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_WOODCUTTER,
    initialCost: {
      ResourceType.wood: 5,
    },
    position: Offset(0, 0),
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_QUARRY,
    initialCost: {
      ResourceType.wood: 5,
    },
    position: Offset(0, 0),
  ),

  copper_mine(
    sprite: Assets.IMAGES_BUILDINGS_COPPER_MINE,
    initialCost: {
      ResourceType.wood: 5,
      ResourceType.stone: 5,
    },
    position: Offset(0, 0),
  ),
  iron_mine(
    sprite: Assets.IMAGES_BUILDINGS_IRON_MINE,
    initialCost: {
      ResourceType.wood: 10,
      ResourceType.stone: 10,
    },
    position: Offset(0, 0),
  ),
  gold_mine(
    sprite: Assets.IMAGES_BUILDINGS_GOLD_MINE,
    initialCost: {
      ResourceType.wood: 15,
      ResourceType.stone: 15,
    },
    position: Offset(0, 0),
  ),

  barracks(
    sprite: Assets.IMAGES_BUILDINGS_BARRACKS,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.75, 0.25),
  ),
  archery(
    sprite: Assets.IMAGES_BUILDINGS_ARCHERY,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.25, 0.75),
  ),
  cavalry(
    sprite: Assets.IMAGES_BUILDINGS_CAVALRY,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.75, 0.75),
  ),
  workshop(
    sprite: Assets.IMAGES_BUILDINGS_WORKSHOP,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.25, 0.25),
  ),
  fortress(
    sprite: Assets.IMAGES_BUILDINGS_FORTRESS,
    initialCost: {
      ResourceType.wood: 50,
      ResourceType.stone: 50,
    },
    position: Offset(0.5, 0.66),
  );

  final String sprite;
  final ResourceMap initialCost;
  final Offset position;

  const BuildingType({
    required this.sprite,
    required this.initialCost,
    required this.position,
  });

  ResourceMap cost(int level) => {};

  double constructionTime(int level) {
    return 0;
  }

  double productionTime(int level) {
    return level * 10;
  }

  @override
  String toString() => name.replaceAll('_', ' ');
}
