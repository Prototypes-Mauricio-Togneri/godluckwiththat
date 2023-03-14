import 'package:tensionplanet/components/base/node.dart';
import 'package:tensionplanet/components/base/sprite_group.dart';
import 'package:tensionplanet/components/game/buildings/assemblers/circuit_assembly.dart';
import 'package:tensionplanet/components/game/buildings/assemblers/gear_assembly.dart';
import 'package:tensionplanet/components/game/buildings/extractors/coal_mine.dart';
import 'package:tensionplanet/components/game/buildings/extractors/copper_mine.dart';
import 'package:tensionplanet/components/game/buildings/extractors/iron_mine.dart';
import 'package:tensionplanet/components/game/buildings/extractors/oil_rig.dart';
import 'package:tensionplanet/components/game/buildings/extractors/stone_mine.dart';
import 'package:tensionplanet/components/game/buildings/factories/drone_factory.dart';
import 'package:tensionplanet/components/game/buildings/power_plants/coal_power_plant.dart';
import 'package:tensionplanet/components/game/buildings/power_plants/solar_panel.dart';
import 'package:tensionplanet/components/game/buildings/power_plants/wind_turbine.dart';
import 'package:tensionplanet/components/game/buildings/processors/chemical_plant.dart';
import 'package:tensionplanet/components/game/buildings/processors/copper_smelter.dart';
import 'package:tensionplanet/components/game/buildings/processors/iron_smelter.dart';
import 'package:tensionplanet/components/game/buildings/processors/steel_smelter.dart';
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

mixin NodeHandler on BaseGameComponent {
  final Map<String, SpriteGroup> spriteGroups = {};

  void loadNodes(JsonMatch json) {
    addHeadquarters(
      location: json.headquarters.location.location,
      inventory: Inventory.fromJson(json.headquarters.inventory),
      connections: [],
    );

    for (final JsonBuilding json in json.getBuildings(NodeType.solar_panel)) {
      _addSolarPanel(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.wind_turbine)) {
      _addWindTurbine(
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

    for (final JsonBuilding json in json.getBuildings(NodeType.stone_mine)) {
      _addStoneMine(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

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

    for (final JsonBuilding json in json.getBuildings(NodeType.steel_smelter)) {
      _addSteelSmelter(
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

    for (final JsonBuilding json in json.getBuildings(NodeType.gear_assembly)) {
      _addGearAssembly(
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

    for (final JsonBuilding json in json.getBuildings(NodeType.drone_factory)) {
      _addDroneFactory(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
      );
    }

    for (final JsonBuilding json in json.getBuildings(NodeType.warehouse)) {
      _addWarehouse(
        location: json.location.location,
        inventory: Inventory.fromJson(json.inventory),
        connections: [],
        resourceType: ResourceType.energy, // TODO(momo): change
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

  void _reloadPatch(PatchType type) {
    spriteGroups[type.sprite]!.load(state.patches.locations(type));
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
        type: nodeType,
        resourceType: resourceType,
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
  }) {
    try {
      if (sendDronesBack) {
        final Headquarters headquarters = state.headquarters;
        headquarters.inventory
            .addResource(Resource(ResourceType.drone, node.totalDrones));
      }

      removeComponent(node);
      state.removeNode(node);
    } catch (e) {
      // ignore
    }
  }

  bool buildConstructionNode({
    required NodeType nodeType,
    required ResourceType? resourceType,
    required Location location,
    required MapTile tile,
    required Patch? patch,
  }) {
    final canBeBuilt = _canBeBuilt(
      type: nodeType,
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

  bool _canBeBuilt({
    required NodeType type,
    required MapTile tile,
    required Patch? patch,
  }) {
    switch (type) {
      case NodeType.solar_panel:
      case NodeType.wind_turbine:
      case NodeType.coal_power_plant:
      case NodeType.iron_smelter:
      case NodeType.copper_smelter:
      case NodeType.steel_smelter:
      case NodeType.chemical_plant:
      case NodeType.gear_assembly:
      case NodeType.circuit_assembly:
      case NodeType.drone_factory:
      case NodeType.warehouse:
        return tile.isSoil && (patch == null);
      case NodeType.iron_mine:
        return patch?.isIron ?? false;
      case NodeType.copper_mine:
        return patch?.isCopper ?? false;
      case NodeType.coal_mine:
        return patch?.isCoal ?? false;
      case NodeType.oil_rig:
        return patch?.isOil ?? false;
      case NodeType.stone_mine:
        return patch?.isStone ?? false;
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
      case NodeType.solar_panel:
        return _addSolarPanel(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.wind_turbine:
        return _addWindTurbine(
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
      case NodeType.stone_mine:
        return _addStoneMine(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
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
      case NodeType.steel_smelter:
        return _addSteelSmelter(
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
      case NodeType.gear_assembly:
        return _addGearAssembly(
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
      case NodeType.drone_factory:
        return _addDroneFactory(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
        );
      case NodeType.warehouse:
        return _addWarehouse(
          location: location,
          inventory: Inventory.fromNodeType(nodeType),
          connections: [],
          resourceType: resourceType!,
        );
      case NodeType.headquarters:
        throw Exception('Headquarters cannot be built');
    }
  }
}
