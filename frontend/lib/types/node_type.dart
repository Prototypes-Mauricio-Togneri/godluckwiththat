import 'package:tensionplanet/extensions/resource_map_extension.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/assets.dart';

enum NodeType {
  headquarters(
    sprite: Assets.IMAGES_BUILDINGS_OTHER_HEADQUARTERS,
    productionTime: 0,
    cost: {},
    input: {},
    output: {},
  ),

  // energy
  wind_turbine(
    sprite: Assets.IMAGES_BUILDINGS_POWER_PLANTS_WIND_TURBINE,
    productionTime: 5,
    cost: {
      ResourceType.iron_plate: 5,
      ResourceType.copper_plate: 5,
    },
    input: {},
    output: {
      ResourceType.energy: 5,
    },
  ),
  solar_panel(
    sprite: Assets.IMAGES_BUILDINGS_POWER_PLANTS_SOLAR_PANEL,
    productionTime: 5,
    cost: {
      ResourceType.steel: 10,
      ResourceType.concrete: 10,
    },
    input: {},
    output: {
      ResourceType.energy: 1,
    },
  ),
  coal_power_plant(
    sprite: Assets.IMAGES_BUILDINGS_POWER_PLANTS_COAL_POWER_PLANT,
    productionTime: 5,
    cost: {
      ResourceType.steel: 20,
      ResourceType.concrete: 20,
    },
    input: {
      ResourceType.coal_ore: 1,
      ResourceType.water: 1,
    },
    output: {
      ResourceType.energy: 10,
    },
  ),
  oil_power_plant(
    sprite: Assets.IMAGES_BUILDINGS_POWER_PLANTS_OIL_POWER_PLANT,
    productionTime: 10,
    cost: {
      ResourceType.steel: 30,
      ResourceType.concrete: 30,
    },
    input: {
      ResourceType.crude_oil: 1,
      ResourceType.water: 1,
    },
    output: {
      ResourceType.energy: 20,
    },
  ),
  nuclear_power_plant(
    sprite: Assets.IMAGES_BUILDINGS_POWER_PLANTS_NUCLEAR_POWER_PLANT,
    productionTime: 20,
    cost: {
      ResourceType.steel: 50,
      ResourceType.concrete: 50,
    },
    input: {
      ResourceType.uranium_ore: 1,
      ResourceType.water: 1,
    },
    output: {
      ResourceType.energy: 50,
    },
  ),

  // extractors
  iron_mine(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_IRON_MINE,
    productionTime: 1,
    cost: {
      ResourceType.iron_plate: 5,
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
    productionTime: 1,
    cost: {
      ResourceType.iron_plate: 5,
    },
    input: {
      ResourceType.energy: 1,
    },
    output: {
      ResourceType.copper_ore: 1,
    },
  ),
  stone_mine(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_STONE_MINE,
    productionTime: 1,
    cost: {
      ResourceType.iron_plate: 10,
      ResourceType.copper_plate: 10,
    },
    input: {
      ResourceType.energy: 1,
    },
    output: {
      ResourceType.stone_ore: 1,
    },
  ),
  water_pump(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_WATER_PUMP,
    productionTime: 1,
    cost: {
      ResourceType.iron_plate: 15,
      ResourceType.copper_plate: 15,
    },
    input: {
      ResourceType.energy: 1,
    },
    output: {
      ResourceType.water: 1,
    },
  ),
  coal_mine(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_COAL_MINE,
    productionTime: 2,
    cost: {
      ResourceType.iron_plate: 15,
      ResourceType.concrete: 15,
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
    productionTime: 2,
    cost: {
      ResourceType.steel: 10,
      ResourceType.concrete: 10,
    },
    input: {
      ResourceType.energy: 2,
    },
    output: {
      ResourceType.crude_oil: 1,
    },
  ),
  titanium_mine(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_TITANIUM_MINE,
    productionTime: 3,
    cost: {
      ResourceType.steel: 20,
      ResourceType.concrete: 20,
    },
    input: {
      ResourceType.energy: 3,
    },
    output: {
      ResourceType.titanium_ore: 1,
    },
  ),
  uranium_mine(
    sprite: Assets.IMAGES_BUILDINGS_EXTRACTORS_URANIUM_MINE,
    productionTime: 3,
    cost: {
      ResourceType.steel: 30,
      ResourceType.concrete: 30,
    },
    input: {
      ResourceType.energy: 3,
    },
    output: {
      ResourceType.uranium_ore: 1,
    },
  ),

  // processors
  iron_smelter(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_IRON_SMELTER,
    productionTime: 1,
    cost: {
      ResourceType.iron_plate: 10,
    },
    input: {
      ResourceType.energy: 1,
      ResourceType.iron_ore: 1,
    },
    output: {
      ResourceType.iron_plate: 1,
    },
  ),
  copper_smelter(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_COPPER_SMELTER,
    productionTime: 1,
    cost: {
      ResourceType.iron_plate: 10,
    },
    input: {
      ResourceType.energy: 1,
      ResourceType.copper_ore: 1,
    },
    output: {
      ResourceType.copper_plate: 1,
    },
  ),
  stone_smelter(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_STONE_SMELTER,
    productionTime: 1,
    cost: {
      ResourceType.iron_plate: 10,
      ResourceType.copper_plate: 10,
    },
    input: {
      ResourceType.energy: 1,
      ResourceType.stone_ore: 1,
      ResourceType.water: 1,
    },
    output: {
      ResourceType.concrete: 1,
    },
  ),
  steel_smelter(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_STEEL_SMELTER,
    productionTime: 2,
    cost: {
      ResourceType.iron_plate: 15,
      ResourceType.concrete: 15,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.coal_ore: 1,
      ResourceType.iron_plate: 1,
    },
    output: {
      ResourceType.steel: 1,
    },
  ),
  polymer_plant(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_POLYMER_PLANT,
    productionTime: 2,
    cost: {
      ResourceType.steel: 10,
      ResourceType.concrete: 10,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.coal_ore: 1,
      ResourceType.crude_oil: 1,
    },
    output: {
      ResourceType.plastic: 1,
    },
  ),
  chemical_plant(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_CHEMICAL_PLANT,
    productionTime: 2,
    cost: {
      ResourceType.steel: 15,
      ResourceType.concrete: 15,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.water: 1,
      ResourceType.crude_oil: 1,
    },
    output: {
      ResourceType.sulfur: 1,
    },
  ),
  oil_refinery(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_OIL_REFINERY,
    productionTime: 3,
    cost: {
      ResourceType.steel: 20,
      ResourceType.concrete: 20,
    },
    input: {
      ResourceType.energy: 3,
      ResourceType.crude_oil: 1,
    },
    output: {
      ResourceType.fuel: 1,
    },
  ),
  titanium_smelter(
    sprite: Assets.IMAGES_BUILDINGS_PROCESSORS_TITANIUM_SMELTER,
    productionTime: 3,
    cost: {
      ResourceType.steel: 30,
      ResourceType.concrete: 30,
    },
    input: {
      ResourceType.energy: 3,
      ResourceType.coal_ore: 1,
      ResourceType.titanium_ore: 1,
    },
    output: {
      ResourceType.titanium_plate: 1,
    },
  ),

  // assemblers
  gear_assembly(
    sprite: Assets.IMAGES_BUILDINGS_ASSEMBLERS_GEAR_ASSEMBLY,
    productionTime: 15,
    cost: {
      ResourceType.iron_plate: 30,
      ResourceType.copper_plate: 30,
      ResourceType.steel: 30,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.iron_plate: 1,
    },
    output: {
      ResourceType.gear: 1,
    },
  ),
  wire_assembly(
    sprite: Assets.IMAGES_BUILDINGS_ASSEMBLERS_WIRE_ASSEMBLY,
    productionTime: 15,
    cost: {
      ResourceType.iron_plate: 30,
      ResourceType.copper_plate: 30,
      ResourceType.steel: 30,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.copper_plate: 1,
    },
    output: {
      ResourceType.wire: 1,
    },
  ),
  transistor_assembly(
    sprite: Assets.IMAGES_BUILDINGS_ASSEMBLERS_TRANSISTOR_ASSEMBLY,
    productionTime: 15,
    cost: {
      ResourceType.iron_plate: 30,
      ResourceType.copper_plate: 30,
      ResourceType.steel: 30,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.wire: 1,
      ResourceType.plastic: 1,
    },
    output: {
      ResourceType.chip: 1,
    },
  ),
  motor_assembly(
    sprite: Assets.IMAGES_BUILDINGS_ASSEMBLERS_MOTOR_ASSEMBLY,
    productionTime: 15,
    cost: {
      ResourceType.iron_plate: 30,
      ResourceType.copper_plate: 30,
      ResourceType.steel: 30,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.iron_plate: 1,
      ResourceType.gear: 1,
    },
    output: {
      ResourceType.motor: 1,
    },
  ),
  chip_assembly(
    sprite: Assets.IMAGES_BUILDINGS_ASSEMBLERS_CHIP_ASSEMBLY,
    productionTime: 15,
    cost: {
      ResourceType.iron_plate: 30,
      ResourceType.copper_plate: 30,
      ResourceType.steel: 30,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.iron_plate: 1,
      ResourceType.gear: 1,
    },
    output: {
      ResourceType.motor: 1,
    },
  ),
  battery_assembly(
    sprite: Assets.IMAGES_BUILDINGS_ASSEMBLERS_BATTERY_ASSEMBLY,
    productionTime: 15,
    cost: {
      ResourceType.iron_plate: 30,
      ResourceType.copper_plate: 30,
      ResourceType.steel: 30,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.iron_plate: 1,
      ResourceType.gear: 1,
    },
    output: {
      ResourceType.motor: 1,
    },
  ),
  circuit_assembly(
    sprite: Assets.IMAGES_BUILDINGS_ASSEMBLERS_CIRCUIT_ASSEMBLY,
    productionTime: 15,
    cost: {
      ResourceType.iron_plate: 30,
      ResourceType.copper_plate: 30,
      ResourceType.steel: 30,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.iron_plate: 1,
      ResourceType.gear: 1,
    },
    output: {
      ResourceType.motor: 1,
    },
  ),
  explosives_assembly(
    sprite: Assets.IMAGES_BUILDINGS_ASSEMBLERS_EXPLOSIVES_ASSEMBLY,
    productionTime: 15,
    cost: {
      ResourceType.iron_plate: 30,
      ResourceType.copper_plate: 30,
      ResourceType.steel: 30,
    },
    input: {
      ResourceType.energy: 2,
      ResourceType.iron_plate: 1,
      ResourceType.gear: 1,
    },
    output: {
      ResourceType.motor: 1,
    },
  ),

  // factories
  drone_factory(
    sprite: Assets.IMAGES_BUILDINGS_FACTORIES_DRONE_FACTORY,
    productionTime: 20,
    cost: {
      ResourceType.iron_plate: 10,
      ResourceType.copper_plate: 10,
    },
    input: {
      ResourceType.energy: 1,
      ResourceType.iron_plate: 1,
      ResourceType.copper_plate: 1,
    },
    output: {
      ResourceType.drone: 1,
    },
  ),

  // other
  warehouse(
    sprite: Assets.IMAGES_BUILDINGS_OTHER_WAREHOUSE,
    productionTime: 0,
    cost: {
      ResourceType.iron_plate: 5,
      ResourceType.copper_plate: 5,
      //ResourceType.steel: 5,
    },
    input: {},
    output: {},
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
        NodeType.wind_turbine,
        NodeType.solar_panel,
        NodeType.coal_power_plant,
        NodeType.oil_power_plant,
        NodeType.nuclear_power_plant,
      ];

  static List<NodeType> extractors() => [
        NodeType.iron_mine,
        NodeType.copper_mine,
        NodeType.stone_mine,
        NodeType.water_pump,
        NodeType.coal_mine,
        NodeType.oil_rig,
        NodeType.titanium_mine,
        NodeType.uranium_mine,
      ];

  static List<NodeType> processors() => [
        NodeType.iron_smelter,
        NodeType.copper_smelter,
        NodeType.stone_smelter,
        NodeType.steel_smelter,
        NodeType.polymer_plant,
        NodeType.chemical_plant,
        NodeType.oil_refinery,
        NodeType.titanium_smelter,
      ];

  static List<NodeType> assemblers() => [
        NodeType.gear_assembly,
        NodeType.wire_assembly,
        NodeType.transistor_assembly,
        NodeType.motor_assembly,
        NodeType.chip_assembly,
        NodeType.battery_assembly,
        NodeType.circuit_assembly,
        NodeType.explosives_assembly,
      ];

  static List<NodeType> factories() => [
        NodeType.drone_factory,
      ];

  static List<NodeType> other() => [
        NodeType.warehouse,
      ];

  @override
  String toString() => name.replaceAll('_', ' ');
}
