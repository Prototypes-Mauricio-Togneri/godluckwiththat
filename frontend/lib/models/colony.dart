import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/models/buildings/consumers/house.dart';
import 'package:godluckwiththat/models/buildings/producers/copper_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/gold_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/iron_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/logging_camp.dart';
import 'package:godluckwiththat/models/buildings/producers/quarry.dart';
import 'package:godluckwiththat/models/inventory/resource_inventory.dart';
import 'package:godluckwiththat/models/inventory/unit_inventory.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/types/unit_type.dart';

class Colony {
  final ResourceInventory resources;
  final UnitInventory units;
  final Map<BuildingType, Building> buildings;

  num timeElapsed;
  int freeWorkers;
  int territorySlotsUsed;
  int warehouseCapacity;

  Colony({
    required this.resources,
    required this.units,
    required this.buildings,
    required this.timeElapsed,
    required this.freeWorkers,
    required this.territorySlotsUsed,
    required this.warehouseCapacity,
  });

  // ============================ TERRITORY ================================= \\

  int get territorySlotsTotal =>
      townCenter.level * Constants.SLOTS_PER_TOWN_CENTER_LEVEL;

  bool get hasSlotsToBuild => territorySlotsUsed < territorySlotsTotal;

  // ============================ TERRITORY ================================= \\

  bool hasBuilding(BuildingType buildingType) =>
      buildings.containsKey(buildingType);

  Headquarters get townCenter =>
      buildings[BuildingType.headquarters] as Headquarters;

  House get house => buildings[BuildingType.house] as House;

  Farm get farm => buildings[BuildingType.farm] as Farm;

  LoggingCamp get loggingCamp =>
      buildings[BuildingType.woodcutter] as LoggingCamp;

  Quarry get quarry => buildings[BuildingType.quarry] as Quarry;

  CopperMine get copperMine => buildings[BuildingType.copperMine] as CopperMine;

  IronMine get ironMine => buildings[BuildingType.ironMine] as IronMine;

  GoldMine get goldMine => buildings[BuildingType.goldMine] as GoldMine;

  // =========================== TIME ELAPSED =============================== \\

  num get day => (timeElapsed / Constants.SECONDS_PER_DAY) + 1;

  num get year => (day / 365).floor() + 1;

  // ============================ BUILDINGS ================================= \\

  num productionOf(ResourceType resourceType) {
    switch (resourceType) {
      case ResourceType.food:
        return farm.production;
      case ResourceType.wood:
        return loggingCamp.production;
      case ResourceType.stone:
        return quarry.production;
      case ResourceType.copper:
        return copperMine.production;
      case ResourceType.iron:
        return ironMine.production;
      case ResourceType.gold:
        return goldMine.production;
      case ResourceType.faith:
        return 0; // TODO(momo): implement
      case ResourceType.knowledge:
        return 0; // (momo): implement
    }
  }

  bool canBuild(BuildingType buildingType) =>
      resources.hasItems(buildingType.cost(1)) && hasSlotsToBuild;

  void build(BuildingType buildingType) {
    if (canBuild(buildingType)) {
      final Building building = Building.create(
        colony: this,
        buildingType: buildingType,
        level: 1,
        workers: 0,
      );
      buildings[buildingType] = building;
      resources.removeItems(buildingType.cost(1));
    }
  }

  // =========================== POPULATION ================================= \\

  bool get hasFreeWorkers => freeWorkers > 0;

  int get currentPopulation => units.get(UnitType.worker).toInt();

  int get populationLimit {
    final int houseLevel = hasBuilding(BuildingType.house) ? house.level : 0;

    return Constants.BASE_POPULATION_LIMIT +
        (houseLevel * Constants.HOUSE_POPULATION);
  }

  int addFreeWorkers(int amount) {
    freeWorkers += amount;

    return amount;
  }

  int removeFreeWorkers(int amount) {
    freeWorkers -= amount;

    return amount;
  }

  void createWorkers() {
    resources.removeItems(UnitType.worker.cost);
    units.add(UnitType.worker, 1);
    addFreeWorkers(1);
  }

  // ============================= UPDATE =================================== \\

  void update(double dt) {
    timeElapsed += dt;

    for (final Building building in buildings.values) {
      building.update(dt);
    }
  }
}
