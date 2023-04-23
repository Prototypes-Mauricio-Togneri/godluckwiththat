import 'package:flame/extensions.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/utils/assets.dart';

enum BuildingType {
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_HEADQUARTERS,
    initialCost: {},
    position: Offset(0.5, 0.5),
    produces: ResourceType.villager,
  ),
  house(
    sprite: Assets.IMAGES_BUILDINGS_HOUSE,
    initialCost: {
      ResourceType.wood: 2,
    },
    position: Offset(0.5, 0.32),
    produces: null,
  ),
  warehouse(
    sprite: Assets.IMAGES_BUILDINGS_WAREHOUSE,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.32, 0.5),
    produces: null,
  ),

  farm(
    sprite: Assets.IMAGES_BUILDINGS_FARM,
    initialCost: {
      ResourceType.wood: 5,
    },
    position: Offset(0, 0),
    produces: ResourceType.food,
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_WOODCUTTER,
    initialCost: {
      ResourceType.wood: 5,
    },
    position: Offset(0, 0),
    produces: ResourceType.wood,
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_QUARRY,
    initialCost: {
      ResourceType.wood: 5,
    },
    position: Offset(0, 0),
    produces: ResourceType.stone,
  ),

  copper_mine(
    sprite: Assets.IMAGES_BUILDINGS_COPPER_MINE,
    initialCost: {
      ResourceType.wood: 5,
      ResourceType.stone: 5,
    },
    position: Offset(0, 0),
    produces: ResourceType.copper,
  ),
  iron_mine(
    sprite: Assets.IMAGES_BUILDINGS_IRON_MINE,
    initialCost: {
      ResourceType.wood: 10,
      ResourceType.stone: 10,
    },
    position: Offset(0, 0),
    produces: ResourceType.iron,
  ),
  gold_mine(
    sprite: Assets.IMAGES_BUILDINGS_GOLD_MINE,
    initialCost: {
      ResourceType.wood: 15,
      ResourceType.stone: 15,
    },
    position: Offset(0, 0),
    produces: ResourceType.gold,
  ),

  barracks(
    sprite: Assets.IMAGES_BUILDINGS_BARRACKS,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.75, 0.25),
    produces: null,
  ),
  archery(
    sprite: Assets.IMAGES_BUILDINGS_ARCHERY,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.25, 0.75),
    produces: null,
  ),
  cavalry(
    sprite: Assets.IMAGES_BUILDINGS_CAVALRY,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.75, 0.75),
    produces: null,
  ),
  workshop(
    sprite: Assets.IMAGES_BUILDINGS_WORKSHOP,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    position: Offset(0.25, 0.25),
    produces: null,
  ),
  fortress(
    sprite: Assets.IMAGES_BUILDINGS_FORTRESS,
    initialCost: {
      ResourceType.wood: 50,
      ResourceType.stone: 50,
    },
    position: Offset(0.5, 0.66),
    produces: null,
  );

  final String sprite;
  final ResourceMap initialCost;
  final Offset position;
  final ResourceType? produces;

  const BuildingType({
    required this.sprite,
    required this.initialCost,
    required this.position,
    required this.produces,
  });

  bool get isProducer => produces != null;

  ResourceMap cost(int level) => {
        ResourceType.wood: level * 100,
        ResourceType.stone: level * 10,
      };

  double constructionTime(int level) {
    return 0;
  }

  double productionTime(int level) {
    return level * 10;
  }

  @override
  String toString() => name.replaceAll('_', ' ');
}
