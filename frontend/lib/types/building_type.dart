import 'package:godluckwiththat/extensions/item_map_extension.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';

enum BuildingType {
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_CONSUMERS_HOUSE,
    initialCost: {
      ResourceType.wood: 100,
    },
    produces: null,
  ),
  house(
    sprite: Assets.IMAGES_BUILDINGS_CONSUMERS_HOUSE,
    initialCost: {
      ResourceType.wood: 50,
    },
    produces: null,
  ),

  farm(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_FARM,
    initialCost: {
      ResourceType.wood: 50,
    },
    produces: ResourceType.food,
  ),
  woodcutter(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_WOODCUTTER,
    initialCost: {
      ResourceType.wood: 50,
    },
    produces: ResourceType.wood,
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_QUARRY,
    initialCost: {
      ResourceType.wood: 100,
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

  ResourceMap cost(int level) => initialCost.multiply(level);

  @override
  String toString() => name.replaceAll('_', ' ');
}
