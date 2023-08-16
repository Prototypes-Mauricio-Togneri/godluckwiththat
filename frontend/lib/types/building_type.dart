import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';

enum BuildingType {
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_MISC_HEADQUARTERS,
    initialCost: {
      ResourceType.wood: 100,
      ResourceType.stone: 50,
    },
    produces: null,
  ),
  house(
    sprite: Assets.IMAGES_BUILDINGS_MISC_HOUSE,
    initialCost: {
      ResourceType.wood: 100,
    },
    produces: null,
  ),
  warehouse(
    sprite: Assets.IMAGES_BUILDINGS_MISC_WAREHOUSE,
    initialCost: {
      ResourceType.wood: 200,
      ResourceType.stone: 100,
    },
    produces: null,
  ),

  well(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_WELL,
    initialCost: {
      ResourceType.wood: 50,
    },
    produces: ResourceType.water,
  ),
  field(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_FIELD,
    initialCost: {
      ResourceType.wood: 100,
    },
    produces: ResourceType.food,
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_WOODCUTTER,
    initialCost: {
      ResourceType.wood: 150,
    },
    produces: ResourceType.wood,
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_QUARRY,
    initialCost: {
      ResourceType.wood: 200,
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

  ResourceMap cost(int level) => initialCost.multiply(level);

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
