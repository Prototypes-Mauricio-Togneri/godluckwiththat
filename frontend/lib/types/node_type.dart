import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/assets.dart';

enum NodeType {
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_HEADQUARTERS_HEADQUARTERS,
    productionTime: 0,
    cost: {},
    input: {},
    output: {},
  ),

  // energy
  solar_panel(
    sprite: Assets.IMAGES_BUILDINGS_POWER_PLANTS_SOLAR_PANEL,
    productionTime: 5,
    cost: {
      ResourceType.iron_block: 2,
    },
    input: {},
    output: {
      ResourceType.energy: 1,
    },
  ),
  wind_turbine(
    sprite: Assets.IMAGES_BUILDINGS_POWER_PLANTS_WIND_TURBINE,
    productionTime: 5,
    cost: {
      ResourceType.iron_block: 10,
      ResourceType.copper_block: 10,
      ResourceType.steel: 10,
    },
    input: {},
    output: {
      ResourceType.energy: 5,
    },
  ),
  coal_power_plant(
    sprite: Assets.IMAGES_BUILDINGS_POWER_PLANTS_COAL_POWER_PLANT,
    productionTime: 5,
    cost: {
      ResourceType.iron_block: 20,
      ResourceType.copper_block: 20,
      ResourceType.steel: 20,
    },
    input: {
      ResourceType.coal_ore: 1,
    },
    output: {
      ResourceType.energy: 20,
    },
  ),

  // extractors
  iron_mine(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_IRON_MINE,
    productionTime: 10,
    cost: {
      ResourceType.iron_block: 2,
    },
    input: {
      ResourceType.energy: 1,
    },
    output: {
      ResourceType.iron_ore: 1,
    },
  ),
  copper_mine(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_COPPER_MINE,
    productionTime: 10,
    cost: {
      ResourceType.iron_block: 2,
    },
    input: {
      ResourceType.energy: 1,
    },
    output: {
      ResourceType.copper_ore: 1,
    },
  ),
  coal_mine(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_COAL_MINE,
    productionTime: 10,
    cost: {
      ResourceType.iron_block: 2,
      ResourceType.copper_block: 2,
    },
    input: {
      ResourceType.energy: 2,
    },
    output: {
      ResourceType.coal_ore: 1,
    },
  ),
  oil_rig(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_OIL_RIG,
    productionTime: 10,
    cost: {
      ResourceType.iron_block: 10,
      ResourceType.copper_block: 10,
      ResourceType.steel: 10,
    },
    input: {
      ResourceType.energy: 2,
    },
    output: {
      ResourceType.oil: 1,
    },
  ),
  stone_mine(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_STONE_MINE,
    productionTime: 10,
    cost: {
      ResourceType.iron_block: 2,
      ResourceType.copper_block: 2,
    },
    input: {
      ResourceType.energy: 3,
    },
    output: {
      ResourceType.stone_ore: 1,
    },
  ),

  // processors
  iron_smelter(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_IRON_SMELTER,
    productionTime: 15,
    cost: {
      ResourceType.iron_block: 2,
    },
    input: {
      ResourceType.energy: 1,
      ResourceType.iron_ore: 1,
    },
    output: {
      ResourceType.iron_block: 1,
    },
  ),
  copper_smelter(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_COPPER_SMELTER,
    productionTime: 15,
    cost: {
      ResourceType.iron_block: 2,
    },
    input: {
      ResourceType.energy: 1,
      ResourceType.copper_ore: 1,
    },
    output: {
      ResourceType.copper_block: 1,
    },
  ),
  steel_smelter(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_STEEL_SMELTER,
    productionTime: 15,
    cost: {
      ResourceType.iron_block: 20,
      ResourceType.copper_block: 20,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.iron_block: 1,
      ResourceType.coal_ore: 1,
    },
    output: {
      ResourceType.steel: 1,
    },
  ),
  chemical_plant(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_CHEMICAL_PLANT,
    productionTime: 15,
    cost: {
      ResourceType.iron_block: 20,
      ResourceType.copper_block: 20,
      ResourceType.steel: 20,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.oil: 2,
    },
    output: {
      ResourceType.plastic: 1,
    },
  ),

  // assemblers
  gear_assembly(
    sprite: Assets.IMAGES_BUILDINGS_ASSEMBLERS_GEAR_ASSEMBLY,
    productionTime: 15,
    cost: {
      ResourceType.iron_block: 30,
      ResourceType.copper_block: 30,
      ResourceType.steel: 30,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.steel: 1,
    },
    output: {
      ResourceType.gear: 1,
    },
  ),
  circuit_assembly(
    sprite: Assets.IMAGES_BUILDINGS_ASSEMBLERS_CIRCUIT_ASSEMBLY,
    productionTime: 15,
    cost: {
      ResourceType.iron_block: 30,
      ResourceType.copper_block: 30,
      ResourceType.steel: 30,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.copper_block: 1,
      ResourceType.plastic: 1,
    },
    output: {
      ResourceType.circuit: 1,
    },
  ),

  // factories
  drone_factory(
    sprite: Assets.IMAGES_BUILDINGS_FACTORIES_DRONE_FACTORY,
    productionTime: 20,
    cost: {
      ResourceType.iron_block: 10,
      ResourceType.copper_block: 10,
    },
    input: {
      ResourceType.energy: 1,
      ResourceType.iron_block: 1,
      ResourceType.copper_block: 1,
    },
    output: {
      ResourceType.drone: 1,
    },
  );

  final String sprite;
  final int productionTime;
  final ResourceMap cost;
  final ResourceMap input;
  final ResourceMap output;

  const NodeType({
    required this.sprite,
    required this.productionTime,
    required this.cost,
    required this.input,
    required this.output,
  });

  static List<NodeType> powerPlants() => [
        NodeType.solar_panel,
        NodeType.wind_turbine,
        NodeType.coal_power_plant,
      ];

  static List<NodeType> extractors() => [
        NodeType.iron_mine,
        NodeType.copper_mine,
        NodeType.coal_mine,
        NodeType.oil_rig,
        NodeType.stone_mine,
      ];

  static List<NodeType> processors() => [
        NodeType.iron_smelter,
        NodeType.copper_smelter,
        NodeType.steel_smelter,
        NodeType.chemical_plant,
      ];

  static List<NodeType> assemblers() => [
        NodeType.gear_assembly,
        NodeType.circuit_assembly,
      ];

  static List<NodeType> factories() => [
        NodeType.drone_factory,
      ];

  @override
  String toString() => name.replaceAll('_', ' ');
}
