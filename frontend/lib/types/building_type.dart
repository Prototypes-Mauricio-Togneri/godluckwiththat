import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/utils/assets.dart';

enum BuildingType {
  house(
    sprite: Assets.IMAGES_BUILDINGS_MISC_HOUSE,
    initialCost: {
      ResourceType.wood: 2,
    },
    produces: null,
  ),
  warehouse(
    sprite: Assets.IMAGES_BUILDINGS_MISC_WAREHOUSE,
    initialCost: {
      ResourceType.wood: 20,
      ResourceType.stone: 20,
    },
    produces: null,
  ),

  well(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_WELL,
    initialCost: {
      ResourceType.wood: 5,
    },
    produces: ResourceType.food,
  ),
  field(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_FIELD,
    initialCost: {
      ResourceType.wood: 5,
    },
    produces: ResourceType.food,
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_WOODCUTTER,
    initialCost: {
      ResourceType.wood: 5,
    },
    produces: ResourceType.wood,
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_QUARRY,
    initialCost: {
      ResourceType.wood: 5,
    },
    produces: ResourceType.stone,
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
      case BuildingType.house:
      case BuildingType.warehouse:
        return {
          ResourceType.wood: level * 100,
          ResourceType.stone: level * 10,
        };
      case BuildingType.well:
      case BuildingType.field:
      case BuildingType.woodcutter:
      case BuildingType.quarry:
        return {
          ResourceType.wood: level * 100,
        };
    }
  }

  double constructionTime(int level) {
    return 0;
  }

  int get productionRate {
    switch (this) {
      case BuildingType.well:
        return Constants.WATER_PRODUCTION_RATE;
      case BuildingType.field:
        return Constants.FIELD_PRODUCTION_RATE;
      case BuildingType.woodcutter:
        return Constants.WOODCUTTER_PRODUCTION_RATE;
      case BuildingType.quarry:
        return Constants.QUARRY_PRODUCTION_RATE;
      default:
        return 0;
    }
  }

  bool get canHostVillagers {
    switch (this) {
      case BuildingType.well:
      case BuildingType.field:
      case BuildingType.woodcutter:
      case BuildingType.quarry:
        return true;
      default:
        return false;
    }
  }

  @override
  String toString() => name.replaceAll('_', ' ');
}
