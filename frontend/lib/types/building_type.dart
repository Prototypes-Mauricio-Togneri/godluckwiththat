import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';

enum BuildingType {
  townCenter(
    sprite: Assets.IMAGES_BUILDINGS_CONSUMERS_HOUSE,
    initialCost: {
      ResourceType.wood: 100,
    },
  ),
  house(
    sprite: Assets.IMAGES_BUILDINGS_CONSUMERS_HOUSE,
    initialCost: {
      ResourceType.wood: 50,
    },
  ),

  farm(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_FARM,
    initialCost: {
      ResourceType.wood: 50,
    },
  ),
  loggingCamp(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_LOGGING_CAMP,
    initialCost: {
      ResourceType.wood: 50,
    },
  ),
  quarry(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_QUARRY,
    initialCost: {
      ResourceType.wood: 100,
    },
  ),
  copperMine(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_QUARRY,
    initialCost: {
      ResourceType.wood: 100,
    },
  ),
  ironMine(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_QUARRY,
    initialCost: {
      ResourceType.wood: 100,
    },
  ),
  goldMine(
    sprite: Assets.IMAGES_BUILDINGS_PRODUCERS_QUARRY,
    initialCost: {
      ResourceType.wood: 100,
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
