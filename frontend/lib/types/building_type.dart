import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/utils/assets.dart';

enum BuildingType {
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_HEADQUARTERS,
    initialCost: {},
    produces: ResourceType.villager,
  ),
  house(
    sprite: Assets.IMAGES_BUILDINGS_HOUSE,
    initialCost: {
      ResourceType.wood: 2,
    },
    produces: null,
  ),
  warehouse(
    sprite: Assets.IMAGES_BUILDINGS_WAREHOUSE,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    produces: null,
  ),

  farm(
    sprite: Assets.IMAGES_BUILDINGS_FARM,
    initialCost: {
      ResourceType.wood: 5,
    },
    produces: ResourceType.food,
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_WOODCUTTER,
    initialCost: {
      ResourceType.wood: 5,
    },
    produces: ResourceType.wood,
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_QUARRY,
    initialCost: {
      ResourceType.wood: 5,
    },
    produces: ResourceType.stone,
  ),

  copper_mine(
    sprite: Assets.IMAGES_BUILDINGS_COPPER_MINE,
    initialCost: {
      ResourceType.wood: 5,
      ResourceType.stone: 5,
    },
    produces: ResourceType.copper,
  ),
  iron_mine(
    sprite: Assets.IMAGES_BUILDINGS_IRON_MINE,
    initialCost: {
      ResourceType.wood: 10,
      ResourceType.stone: 10,
    },
    produces: ResourceType.iron,
  ),
  gold_mine(
    sprite: Assets.IMAGES_BUILDINGS_GOLD_MINE,
    initialCost: {
      ResourceType.wood: 15,
      ResourceType.stone: 15,
    },
    produces: ResourceType.gold,
  ),

  barracks(
    sprite: Assets.IMAGES_BUILDINGS_BARRACKS,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    produces: null,
  ),
  archery(
    sprite: Assets.IMAGES_BUILDINGS_ARCHERY,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    produces: null,
  ),
  cavalry(
    sprite: Assets.IMAGES_BUILDINGS_CAVALRY,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    produces: null,
  ),
  workshop(
    sprite: Assets.IMAGES_BUILDINGS_WORKSHOP,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    produces: null,
  ),
  fortress(
    sprite: Assets.IMAGES_BUILDINGS_FORTRESS,
    initialCost: {
      ResourceType.wood: 50,
      ResourceType.stone: 50,
    },
    produces: null,
  );

  final String sprite;
  final ResourceMap initialCost;
  final ResourceType? produces;

  const BuildingType({
    required this.sprite,
    required this.initialCost,
    required this.produces,
  });

  bool get isProducer => produces != null;

  ResourceMap cost(int level) {
    switch (this) {
      case BuildingType.headquarters:
      case BuildingType.house:
      case BuildingType.warehouse:
        return {
          ResourceType.wood: level * 100,
          ResourceType.stone: level * 10,
        };
      case BuildingType.farm:
      case BuildingType.woodcutter:
      case BuildingType.quarry:
        return {
          ResourceType.wood: level * 100,
        };
      case BuildingType.copper_mine:
      case BuildingType.iron_mine:
      case BuildingType.gold_mine:
        return {
          ResourceType.wood: level * 200,
          ResourceType.stone: level * 20,
        };
      case BuildingType.barracks:
      case BuildingType.archery:
      case BuildingType.cavalry:
      case BuildingType.workshop:
      case BuildingType.fortress:
        return {
          ResourceType.wood: level * 500,
          ResourceType.stone: level * 50,
        };
      default:
        return {};
    }
  }

  double constructionTime(int level) {
    return 0;
  }

  int get productionRate {
    switch (this) {
      case BuildingType.farm:
        return Constants.FARM_PRODUCTION_RATE;
      case BuildingType.woodcutter:
        return Constants.WOODCUTTER_PRODUCTION_RATE;
      case BuildingType.quarry:
        return Constants.QUARRY_PRODUCTION_RATE;
      case BuildingType.copper_mine:
        return Constants.COPPER_MINE_PRODUCTION_RATE;
      case BuildingType.iron_mine:
        return Constants.IRON_MINE_PRODUCTION_RATE;
      case BuildingType.gold_mine:
        return Constants.GOLD_MINE_PRODUCTION_RATE;
      default:
        return 0;
    }
  }

  bool get canHostVillagers {
    switch (this) {
      case BuildingType.headquarters:
      case BuildingType.farm:
      case BuildingType.woodcutter:
      case BuildingType.quarry:
      case BuildingType.copper_mine:
      case BuildingType.iron_mine:
      case BuildingType.gold_mine:
        return true;
      default:
        return false;
    }
  }

  @override
  String toString() => name.replaceAll('_', ' ');
}
