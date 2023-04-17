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
    position: Offset(0.5, 0.16),
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_WOODCUTTER,
    initialCost: {
      ResourceType.wood: 5,
    },
    position: Offset(0.82, 0.5),
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_QUARRY,
    initialCost: {
      ResourceType.wood: 5,
    },
    position: Offset(0.16, 0.5),
  ),

  copper_mine(
    sprite: Assets.IMAGES_BUILDINGS_COPPER_MINE,
    initialCost: {
      ResourceType.wood: 5,
      ResourceType.stone: 5,
    },
    position: Offset(0.5, 0.82),
  ),
  iron_mine(
    sprite: Assets.IMAGES_BUILDINGS_IRON_MINE,
    initialCost: {
      ResourceType.wood: 10,
      ResourceType.stone: 10,
    },
    position: Offset(0.5, 0.82),
  ),
  gold_mine(
    sprite: Assets.IMAGES_BUILDINGS_GOLD_MINE,
    initialCost: {
      ResourceType.wood: 15,
      ResourceType.stone: 15,
    },
    position: Offset(0.5, 0.82),
  ),

  barracks(
    sprite: Assets.IMAGES_BUILDINGS_BARRACKS,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.75, 0.32),
  ),
  archery(
    sprite: Assets.IMAGES_BUILDINGS_BARRACKS,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.25, 0.66),
  ),
  cavalry(
    sprite: Assets.IMAGES_BUILDINGS_CAVALRY,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.75, 0.66),
  ),
  workshop(
    sprite: Assets.IMAGES_BUILDINGS_WORKSHOP,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.25, 0.32),
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

  @override
  String toString() => name.replaceAll('_', ' ');
}
