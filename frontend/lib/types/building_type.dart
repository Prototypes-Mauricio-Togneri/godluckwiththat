import 'package:tensionplanet/utils/assets.dart';

enum BuildingType {
  headquarters(sprite: Assets.IMAGES_BUILDINGS_HEADQUARTERS),
  house(sprite: Assets.IMAGES_BUILDINGS_HOUSE),
  market(sprite: Assets.IMAGES_BUILDINGS_MARKET),
  warehouse(sprite: Assets.IMAGES_BUILDINGS_WAREHOUSE),

  farm(sprite: Assets.IMAGES_BUILDINGS_FARM),
  woodcutter(sprite: Assets.IMAGES_BUILDINGS_WOODCUTTER),
  quarry(sprite: Assets.IMAGES_BUILDINGS_QUARRY),

  copper_mine(sprite: Assets.IMAGES_BUILDINGS_COPPER_MINE),
  iron_mine(sprite: Assets.IMAGES_BUILDINGS_IRON_MINE),
  gold_mine(sprite: Assets.IMAGES_BUILDINGS_GOLD_MINE),

  tower(sprite: Assets.IMAGES_BUILDINGS_TOWER),
  fortress(sprite: Assets.IMAGES_BUILDINGS_FORTRESS);

  final String sprite;

  const BuildingType({
    required this.sprite,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
