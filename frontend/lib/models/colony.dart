import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/dialog/confirmation_dialog.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/models/buildings/passive/house.dart';
import 'package:godluckwiththat/models/buildings/producers/academy.dart';
import 'package:godluckwiththat/models/buildings/producers/altar.dart';
import 'package:godluckwiththat/models/buildings/producers/copper_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/gold_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/iron_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/logging_camp.dart';
import 'package:godluckwiththat/models/buildings/producers/quarry.dart';
import 'package:godluckwiththat/models/future_events/future_event.dart';
import 'package:godluckwiththat/models/inventory/resource_inventory.dart';
import 'package:godluckwiththat/models/inventory/unit_inventory.dart';
import 'package:godluckwiththat/models/past_events/past_event.dart';
import 'package:godluckwiththat/models/past_events/population_limit_reached_event.dart';
import 'package:godluckwiththat/models/past_events/territory_limit_reached_event.dart';
import 'package:godluckwiththat/states/game_state.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/types/unit_type.dart';
import 'package:godluckwiththat/utils/formatter.dart';

class Colony {
  late final GameState state;
  final ResourceInventory resources;
  final UnitInventory units;
  final Map<BuildingType, Building> buildings;
  final List<PastEvent> pastEvents;
  final List<FutureEvent> futureEvents;

  num timeElapsed;
  int freeWorkers;
  int territorySlotsUsed;
  int resourcesCapacity;

  Colony({
    required this.resources,
    required this.units,
    required this.buildings,
    required this.pastEvents,
    required this.futureEvents,
    required this.timeElapsed,
    required this.freeWorkers,
    required this.territorySlotsUsed,
    required this.resourcesCapacity,
  });

  void setState(GameState state) {
    this.state = state;
  }

  // =========================== PAST EVENTS ================================ \\

  void onAllPastEventsClosed() =>
      ConfirmationDialog.clearAllEvents(onAccept: pastEvents.clear);

  void onPastEventClosed(PastEvent event) {
    pastEvents.remove(event);
  }

  void onPastEventSelected(PastEvent event) {
    print('Event');
  }

  void addPastEvent(PastEvent event) {
    pastEvents.add(event);
  }

  // ========================== FUTURE EVENTS =============================== \\

  void onFutureEventSelected(FutureEvent event) {
    print('Event');
  }

  // ============================ TERRITORY ================================= \\

  int get territorySlotsTotal =>
      headquarters.level * Constants.SLOTS_PER_HEADQUARTERS_LEVEL;

  bool get hasSlotsToBuild => territorySlotsUsed < territorySlotsTotal;

  // ============================ TERRITORY ================================= \\

  T getBuilding<T>(BuildingType buildingType) => buildings[buildingType] as T;

  bool hasBuildingType<T>(Type type) =>
      buildings.values.any((Building building) => building.runtimeType == type);

  bool hasBuilding(BuildingType buildingType) =>
      buildings.containsKey(buildingType);

  Headquarters get headquarters =>
      buildings[BuildingType.headquarters] as Headquarters;

  House get house => buildings[BuildingType.house] as House;

  Farm get farm => buildings[BuildingType.farm] as Farm;

  Woodcutter get woodcutter => buildings[BuildingType.woodcutter] as Woodcutter;

  Quarry get quarry => buildings[BuildingType.quarry] as Quarry;

  CopperMine get copperMine => buildings[BuildingType.copperMine] as CopperMine;

  IronMine get ironMine => buildings[BuildingType.ironMine] as IronMine;

  GoldMine get goldMine => buildings[BuildingType.goldMine] as GoldMine;

  Academy get academy => buildings[BuildingType.academy] as Academy;

  Altar get altar => buildings[BuildingType.altar] as Altar;

  // =========================== TIME ELAPSED =============================== \\

  String get time => Formatter.time(timeElapsed);

  // ============================ BUILDINGS ================================= \\

  num productionOf(ResourceType resourceType) =>
      _baseProduction(resourceType) * Constants.PRODUCTION_RATE_MULTIPLIER;

  num _baseProduction(ResourceType resourceType) {
    switch (resourceType) {
      case ResourceType.food:
        return hasBuilding(BuildingType.farm) ? farm.production : 0;
      case ResourceType.wood:
        return hasBuilding(BuildingType.woodcutter) ? woodcutter.production : 0;
      case ResourceType.stone:
        return hasBuilding(BuildingType.quarry) ? quarry.production : 0;
      case ResourceType.copper:
        return hasBuilding(BuildingType.copperMine) ? copperMine.production : 0;
      case ResourceType.iron:
        return hasBuilding(BuildingType.ironMine) ? ironMine.production : 0;
      case ResourceType.gold:
        return hasBuilding(BuildingType.goldMine) ? goldMine.production : 0;
      case ResourceType.faith:
        return hasBuilding(BuildingType.altar)
            ? altar.production
            : 0; // TODO(momo): count shrines and temples
      case ResourceType.knowledge:
        return hasBuilding(BuildingType.academy) ? academy.production : 0;
    }
  }

  bool allowToBuild(BuildingType buildingType) =>
      headquarters.type.allowToBuild(buildingType);

  bool canBuild(BuildingType buildingType) =>
      resources.hasItems(buildingType.cost(1)) && hasSlotsToBuild;

  bool canUpgrade(Building building) =>
      resources.hasItems(building.upgradeCost) && hasSlotsToBuild;

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
      increaseTerritoryUsed();
    }
  }

  void increaseTerritoryUsed() {
    territorySlotsUsed++;

    if (territorySlotsUsed >= territorySlotsTotal) {
      addPastEvent(TerritoryLimitReachedEvent());
    }
  }

  // =========================== POPULATION ================================= \\

  bool get hasFreeWorkers => freeWorkers > 0;

  int get totalWorkers => units.get(UnitType.worker).toInt();

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

  void createWorker() {
    resources.removeItems(UnitType.worker.cost);
    units.add(UnitType.worker, 1);
    addFreeWorkers(1);

    if (totalWorkers >= populationLimit) {
      addPastEvent(PopulationLimitReachedEvent());
    }
  }

  // ============================= UPDATE =================================== \\

  void update(double dt) {
    timeElapsed += dt;

    for (final Building building in buildings.values) {
      building.update(dt);
    }

    final List<FutureEvent> pending = [...futureEvents];

    for (final FutureEvent event in pending) {
      if (event.update(dt)) {
        pending.remove(event);
      }
    }

    futureEvents.clear();
    futureEvents.addAll(pending);
    state.notify();
  }
}
