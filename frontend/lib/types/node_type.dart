import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/types/resource_type.dart';
import 'package:tensionnode/utils/assets.dart';

enum NodeType {
  headquarters(
      sprite: Assets.IMAGES_BUILDINGS_HEADQUARTERS_HEADQUARTERS,
      productionTime: 0,
      cost: {}),
  solar_panel(
      sprite: Assets.IMAGES_BUILDINGS_POWER_PLANTS_SOLAR_PANEL,
      productionTime: 1,
      cost: {
        ResourceType.iron_block: 2,
      }),
  iron_mine(
      sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_IRON_MINE,
      productionTime: 10,
      cost: {
        ResourceType.iron_block: 2,
      }),
  copper_mine(
      sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_COPPER_MINE,
      productionTime: 3,
      cost: {
        ResourceType.iron_block: 2,
      }),
  coal_mine(
      sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_COAL_MINE,
      productionTime: 3,
      cost: {
        ResourceType.iron_block: 2,
        ResourceType.copper_block: 2,
      }),
  stone_mine(
      sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_STONE_MINE,
      productionTime: 3,
      cost: {
        ResourceType.iron_block: 2,
        ResourceType.copper_block: 2,
      }),
  iron_smelter(
      sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_IRON_SMELTER,
      productionTime: 10,
      cost: {
        ResourceType.iron_block: 2,
      }),
  copper_smelter(
      sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_COPPER_SMELTER,
      productionTime: 10,
      cost: {
        ResourceType.iron_block: 2,
      }),
  factory_basic(
      sprite: Assets.IMAGES_BUILDINGS_FACTORIES_FACTORY_BASIC,
      productionTime: 10,
      cost: {
        ResourceType.iron_block: 2,
        ResourceType.copper_block: 2,
      });

  final String sprite;
  final int productionTime;
  final ResourceMap cost;

  const NodeType({
    required this.sprite,
    required this.productionTime,
    required this.cost,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
