import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/base/sprite_group.dart';
import 'package:tensionplanet/components/game/buildings/assemblers/battery_assembly.dart';
import 'package:tensionplanet/components/game/buildings/assemblers/chip_assembly.dart';
import 'package:tensionplanet/components/game/buildings/assemblers/circuit_assembly.dart';
import 'package:tensionplanet/components/game/buildings/assemblers/explosives_assembly.dart';
import 'package:tensionplanet/components/game/buildings/assemblers/gear_assembly.dart';
import 'package:tensionplanet/components/game/buildings/assemblers/motor_assembly.dart';
import 'package:tensionplanet/components/game/buildings/assemblers/transistor_assembly.dart';
import 'package:tensionplanet/components/game/buildings/assemblers/wire_assembly.dart';
import 'package:tensionplanet/components/game/buildings/extractors/coal_mine.dart';
import 'package:tensionplanet/components/game/buildings/extractors/copper_mine.dart';
import 'package:tensionplanet/components/game/buildings/extractors/iron_mine.dart';
import 'package:tensionplanet/components/game/buildings/extractors/oil_rig.dart';
import 'package:tensionplanet/components/game/buildings/extractors/stone_mine.dart';
import 'package:tensionplanet/components/game/buildings/extractors/titanium_mine.dart';
import 'package:tensionplanet/components/game/buildings/extractors/uranium_mine.dart';
import 'package:tensionplanet/components/game/buildings/extractors/water_pump.dart';
import 'package:tensionplanet/components/game/buildings/factories/drone_factory.dart';
import 'package:tensionplanet/components/game/buildings/power_plants/coal_power_plant.dart';
import 'package:tensionplanet/components/game/buildings/power_plants/nuclear_power_plant.dart';
import 'package:tensionplanet/components/game/buildings/power_plants/oil_power_plant.dart';
import 'package:tensionplanet/components/game/buildings/power_plants/solar_panel.dart';
import 'package:tensionplanet/components/game/buildings/power_plants/wind_turbine.dart';
import 'package:tensionplanet/components/game/buildings/processors/chemical_plant.dart';
import 'package:tensionplanet/components/game/buildings/processors/copper_smelter.dart';
import 'package:tensionplanet/components/game/buildings/processors/iron_smelter.dart';
import 'package:tensionplanet/components/game/buildings/processors/oil_refinery.dart';
import 'package:tensionplanet/components/game/buildings/processors/polymer_plant.dart';
import 'package:tensionplanet/components/game/buildings/processors/steel_smelter.dart';
import 'package:tensionplanet/components/game/buildings/processors/stone_smelter.dart';
import 'package:tensionplanet/components/game/buildings/processors/titanium_smelter.dart';
import 'package:tensionplanet/components/game/construction.dart';
import 'package:tensionplanet/components/game/headquarters.dart';
import 'package:tensionplanet/components/game/warehouse.dart';
import 'package:tensionplanet/extensions/json_location_extension.dart';
import 'package:tensionplanet/game/base_game_component.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/models/connection.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/location.dart';
import 'package:tensionplanet/models/map_tile.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/types/patch_type.dart';
import 'package:tensionplanet/types/resource_type.dart';
import 'package:tensionplanet/utils/error_handler.dart';

mixin NodeHandler on BaseGameComponent {
  final Map<String, SpriteGroup> spriteGroups = {};

  void loadNodes(JsonMatch json) {
    addHeadquarters(
      location: json.headquarters.location.location,
      inventory: Inventory.fromJson(json.headquarters.inventory),
      connections: [],
    );

    // =============================== ENERGY =============================== \\

    for (final JsonBuilding json in json.getBuildings(NodeType.wind_turbine)) {
      _addWindTurbine(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.solar_panel)) {
      _addSolarPanel(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.coal_power_plant)) {
      _addCoalPowerPlant(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.oil_power_plant)) {
      _addOilPowerPlant(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.nuclear_power_plant)) {
      _addNuclearPowerPlant(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    // ============================= EXTRACTORS============================== \\

    for (final JsonBuilding json in json.getBuildings(NodeType.iron_mine)) {
      _addIronMine(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.copper_mine)) {
      _addCopperMine(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.stone_mine)) {
      _addStoneMine(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.water_pump)) {
      _addWaterPump(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.coal_mine)) {
      _addCoalMine(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.oil_rig)) {
      _addOilRig(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.titanium_mine)) {
      _addTitaniumMine(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.uranium_mine)) {
      _addUraniumMine(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    // ============================= PROCESSORS ============================= \\

    for (final JsonBuilding json in json.getBuildings(NodeType.iron_smelter)) {
      _addIronSmelter(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.copper_smelter)) {
      _addCopperSmelter(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.stone_smelter)) {
      _addStoneSmelter(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.steel_smelter)) {
      _addSteelSmelter(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.polymer_plant)) {
      _addPolymerPlant(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.chemical_plant)) {
      _addChemicalPlant(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.oil_refinery)) {
      _addOilRefinery(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.titanium_smelter)) {
      _addTitaniumSmelter(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    // ============================= ASSEMBLERS ============================= \\

    for (final JsonBuilding json in json.getBuildings(NodeType.gear_assembly)) {
      _addGearAssembly(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.wire_assembly)) {
      _addWireAssembly(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.transistor_assembly)) {
      _addTransistorAssembly(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.motor_assembly)) {
      _addMotorAssembly(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.chip_assembly)) {
      _addChipAssembly(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.battery_assembly)) {
      _addBatteryAssembly(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.circuit_assembly)) {
      _addCircuitAssembly(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json
        in json.getBuildings(NodeType.explosives_assembly)) {
      _addExplosivesAssembly(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    // ============================= FACTORIES ============================== \\

    for (final JsonBuilding json in json.getBuildings(NodeType.drone_factory)) {
      _addDroneFactory(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    // =============================== OTHER ================================ \\

    for (final JsonBuilding json in json.getBuildings(NodeType.warehouse)) {
      _addWarehouse(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
        resourceType: json.resourceType!,
      );
    }

    _addSpriteGroup(PatchType.iron.sprite);
    _addSpriteGroup(PatchType.copper.sprite);
    _addSpriteGroup(PatchType.coal.sprite);
    _addSpriteGroup(PatchType.oil.sprite);
    _addSpriteGroup(PatchType.stone.sprite);

    reloadPatches();
  }

  void _addSpriteGroup(String sprite) {
    final SpriteGroup spriteGroup = SpriteGroup(sprite);
    spriteGroups[sprite] = spriteGroup;
    addToPatchesLayer(spriteGroup);
  }

  void reloadPatches() {
    _reloadPatch(PatchType.iron);
    _reloadPatch(PatchType.copper);
    _reloadPatch(PatchType.coal);
    _reloadPatch(PatchType.oil);
    _reloadPatch(PatchType.stone);
  }

  void _reloadPatch(PatchType patchType) {
    spriteGroups[patchType.sprite]!.load(state.patches.locations(patchType));
  }

  Node addHeadquarters({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(Headquarters(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addConstruction({
    required Location location,
    required NodeType nodeType,
    required ResourceType? resourceType,
  }) =>
      _addNode(Construction(
        location: location,
        nodeType: nodeType,
        resourceType: resourceType,
      ));

  // ================================ ENERGY ================================ \\

  Node _addWindTurbine({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(WindTurbine(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addSolarPanel({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(SolarPanel(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addCoalPowerPlant({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(CoalPowerPlant(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addOilPowerPlant({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(OilPowerPlant(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addNuclearPowerPlant({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(NuclearPowerPlant(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  // ============================== EXTRACTORS ============================== \\

  Node _addIronMine({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(IronMine(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addCopperMine({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(CopperMine(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addStoneMine({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(StoneMine(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addWaterPump({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(WaterPump(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addCoalMine({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(CoalMine(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addOilRig({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(OilRig(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addTitaniumMine({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(TitaniumMine(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addUraniumMine({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(UraniumMine(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  // ============================== PROCESSORS ============================== \\

  Node _addIronSmelter({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(IronSmelter(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addCopperSmelter({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(CopperSmelter(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addStoneSmelter({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(StoneSmelter(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addSteelSmelter({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(SteelSmelter(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addPolymerPlant({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(PolymerPlant(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addChemicalPlant({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(ChemicalPlant(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addOilRefinery({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(OilRefinery(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addTitaniumSmelter({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(TitaniumSmelter(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  // ============================== ASSEMBLERS ============================== \\

  Node _addGearAssembly({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(GearAssembly(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addWireAssembly({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(WireAssembly(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addTransistorAssembly({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(TransistorAssembly(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addMotorAssembly({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(MotorAssembly(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addChipAssembly({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(ChipAssembly(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addBatteryAssembly({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(BatteryAssembly(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addCircuitAssembly({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(CircuitAssembly(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  Node _addExplosivesAssembly({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(ExplosivesAssembly(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  // =============================== FACTORIES ============================== \\

  Node _addDroneFactory({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
  }) =>
      _addNode(DroneFactory(
        location: location,
        inventory: inventory,
        connections: connections,
      ));

  // ================================ OTHER ================================= \\

  Node _addWarehouse({
    required Location location,
    required Inventory inventory,
    required List<Connection> connections,
    required ResourceType resourceType,
  }) =>
      _addNode(Warehouse(
        location: location,
        inventory: inventory,
        connections: connections,
        resourceType: resourceType,
      ));

  Node _addNode(Node node) {
    addComponent(node);
    state.addNode(node);

    return node;
  }

  void removeNode({
    required Node node,
    required bool sendDronesBack,
    required Inventory resourcesBack,
  }) {
    try {
      if (sendDronesBack) {
        state.headquarters.removeDroneConnection(node);
        state.headquarters.inventory.add(resourcesBack);
        state.headquarters.inventory.addResource(Resource(
          ResourceType.drone,
          node.totalDrones,
        ));
      }

      removeComponent(node);
      state.removeNode(node);
    } catch (e) {
      ErrorHandler.process(e);
    }
  }

  bool buildConstructionNode({
    required NodeType nodeType,
    required ResourceType? resourceType,
    required Location location,
    required MapTile tile,
    required Patch? patch,
  }) {
    final canBeBuilt = nodeCanBeBuilt(
      nodeType: nodeType,
      tile: tile,
      patch: patch,
    );

    if (canBeBuilt) {
      _addConstruction(
        location: location,
        nodeType: nodeType,
        resourceType: resourceType,
      );

      return true;
    } else {
      return false;
    }
  }

  bool nodeCanBeBuilt({
    required NodeType nodeType,
    required MapTile tile,
    required Patch? patch,
  }) {
    switch (nodeType) {
      // power plants
      case NodeType.wind_turbine:
      case NodeType.solar_panel:
      case NodeType.coal_power_plant:
      case NodeType.oil_power_plant:
      case NodeType.nuclear_power_plant:

      // processors
      case NodeType.iron_smelter:
      case NodeType.copper_smelter:
      case NodeType.stone_smelter:
      case NodeType.steel_smelter:
      case NodeType.polymer_plant:
      case NodeType.chemical_plant:
      case NodeType.oil_refinery:
      case NodeType.titanium_smelter:

      // assemblies
      case NodeType.gear_assembly:
      case NodeType.wire_assembly:
      case NodeType.transistor_assembly:
      case NodeType.motor_assembly:
      case NodeType.chip_assembly:
      case NodeType.battery_assembly:
      case NodeType.circuit_assembly:
      case NodeType.explosives_assembly:

      // factories
      case NodeType.drone_factory:

      // other
      case NodeType.warehouse:
        return tile.isSoil && (patch == null);

      case NodeType.iron_mine:
        return patch?.isIron ?? false;
      case NodeType.copper_mine:
        return patch?.isCopper ?? false;
      case NodeType.stone_mine:
        return patch?.isStone ?? false;
      case NodeType.water_pump:
        return patch?.isWater ?? false;
      case NodeType.coal_mine:
        return patch?.isCoal ?? false;
      case NodeType.oil_rig:
        return patch?.isOil ?? false;
      case NodeType.titanium_mine:
        return patch?.isTitanium ?? false;
      case NodeType.uranium_mine:
        return patch?.isUranium ?? false;
      case NodeType.headquarters:
        return false;
    }
  }

  Node buildNode({
    required Location location,
    required NodeType nodeType,
    required ResourceType? resourceType,
  }) {
    switch (nodeType) {
      // energy
      case NodeType.wind_turbine:
        return _addWindTurbine(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.solar_panel:
        return _addSolarPanel(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.coal_power_plant:
        return _addCoalPowerPlant(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.oil_power_plant:
        return _addOilPowerPlant(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.nuclear_power_plant:
        return _addNuclearPowerPlant(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );

      // extractors
      case NodeType.iron_mine:
        return _addIronMine(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.copper_mine:
        return _addCopperMine(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.stone_mine:
        return _addStoneMine(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.water_pump:
        return _addWaterPump(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.coal_mine:
        return _addCoalMine(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.oil_rig:
        return _addOilRig(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.titanium_mine:
        return _addTitaniumMine(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.uranium_mine:
        return _addUraniumMine(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );

      // processors
      case NodeType.iron_smelter:
        return _addIronSmelter(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.copper_smelter:
        return _addCopperSmelter(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.stone_smelter:
        return _addStoneSmelter(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.steel_smelter:
        return _addSteelSmelter(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.polymer_plant:
        return _addPolymerPlant(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.chemical_plant:
        return _addChemicalPlant(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.oil_refinery:
        return _addOilRefinery(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.titanium_smelter:
        return _addTitaniumSmelter(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );

      // assemblers
      case NodeType.gear_assembly:
        return _addGearAssembly(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.wire_assembly:
        return _addWireAssembly(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.transistor_assembly:
        return _addTransistorAssembly(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.motor_assembly:
        return _addMotorAssembly(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.chip_assembly:
        return _addChipAssembly(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.battery_assembly:
        return _addBatteryAssembly(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.circuit_assembly:
        return _addCircuitAssembly(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.explosives_assembly:
        return _addExplosivesAssembly(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );

      // factories
      case NodeType.drone_factory:
        return _addDroneFactory(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );

      // other
      case NodeType.warehouse:
        return _addWarehouse(
          location: location,
          inventory: Inventory.fromResourceMap({
            resourceType!: 0,
          }),
          connections: [],
          resourceType: resourceType,
        );
      case NodeType.headquarters:
        throw Exception('Headquarters cannot be built');
    }
  }
}
