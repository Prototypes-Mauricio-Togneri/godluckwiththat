import 'package:tensionnode/services/assets.dart';

enum NodeType {
  solar_panel(
    sprite: Assets.IMAGES_BUILDINGS_SOLAR_PANEL,
    productionTime: 1,
    iron: 0,
    copper: 0,
    steel: 0,
    concrete: 0,
  ),
  iron_mine(
    sprite: Assets.IMAGES_BUILDINGS_IRON_MINE,
    productionTime: 3,
    iron: 0,
    copper: 0,
    steel: 0,
    concrete: 0,
  ),
  copper_mine(
    sprite: Assets.IMAGES_BUILDINGS_COPPER_MINE,
    productionTime: 3,
    iron: 0,
    copper: 0,
    steel: 0,
    concrete: 0,
  ),
  coal_mine(
    sprite: Assets.IMAGES_BUILDINGS_COAL_MINE,
    productionTime: 3,
    iron: 0,
    copper: 0,
    steel: 0,
    concrete: 0,
  ),
  stone_mine(
    sprite: Assets.IMAGES_BUILDINGS_STONE_MINE,
    productionTime: 3,
    iron: 0,
    copper: 0,
    steel: 0,
    concrete: 0,
  ),
  copper_smelter(
    sprite: Assets.IMAGES_BUILDINGS_COPPER_SMELTER,
    productionTime: 10,
    iron: 0,
    copper: 0,
    steel: 0,
    concrete: 0,
  );

  final String sprite;
  final int productionTime;
  final int iron;
  final int copper;
  final int steel;
  final int concrete;

  const NodeType({
    required this.sprite,
    required this.productionTime,
    required this.iron,
    required this.copper,
    required this.steel,
    required this.concrete,
  });
}
