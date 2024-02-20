import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
import 'package:godluckwiththat/models/buildings/consumers/house.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/models/tasks/create_villager_task.dart';
import 'package:godluckwiththat/models/tasks/task.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Colony {
  final Inventory inventory;
  final List<Building> buildings;
  final List<CreateVillagerTask> villagerTasks = [];
  num daysElapsed;
  int freeVillagers;

  Colony({
    required this.inventory,
    required this.buildings,
    required this.daysElapsed,
    required this.freeVillagers,
  });

  // =========================== TIME ELAPSED =============================== \\

  num get day => daysElapsed + 1;

  num get year => (daysElapsed / 365).floor() + 1;

  // ============================ BUILDINGS ================================= \\

  List<Producer> get producers =>
      buildings.where((b) => b.isProducer).map((b) => b as Producer).toList();

  List<Consumer> get consumers =>
      buildings.where((b) => b.isConsumer).map((b) => b as Consumer).toList();

  List<T> buildingsByType<T extends Building>(Type type) =>
      buildings.where((b) => b.runtimeType == type).map((e) => e as T).toList();

  double productionOf(ResourceType resourceType) {
    double total = 0;

    for (final Building building in buildings) {
      if ((building is Producer) && (building.resourceType == resourceType)) {
        total += building.production;
      }
    }

    return total;
  }

  bool canBuild(BuildingType buildingType) =>
      inventory.hasResources(buildingType.cost(1).resources());

  void build(BuildingType buildingType) {
    if (canBuild(buildingType)) {
      final Building building = Building.create(
        colony: this,
        buildingType: buildingType,
        level: 1,
        villagers: 0,
      );
      buildings.add(building);
      inventory.removeMapResources(buildingType.cost(1));
    }
  }

  void addBuildings(List<Building> list) {
    buildings.addAll(list);
  }

  void removeBuilding(Building building) {
    buildings.remove(building);
  }

  // =========================== POPULATION ================================= \\

  bool get hasFreeVillagers => freeVillagers > 0;

  int get currentPopulation => inventory.get(ResourceType.villager).toInt();

  int get populationLimit {
    int total = 0;

    for (final Building building in buildings) {
      if (building is House) {
        total += Constants.HOUSE_POPULATION;
      }
    }

    return total + Constants.BASE_POPULATION_LIMIT;
  }

  int addFreeVillagers(int amount) {
    freeVillagers += amount;

    return amount;
  }

  int removeFreeVillagers(int amount) {
    freeVillagers -= amount;

    return amount;
  }

  // ============================= UPDATE =================================== \\

  void update(double dt) {
    daysElapsed += dt;

    _updateTasks(
      dt: dt,
      tasks: villagerTasks,
      callback: (task) {
        inventory.addResource(Resource.one(ResourceType.villager));
        addFreeVillagers(task.villagers);
      },
    );

    for (final Building building in buildings) {
      building.update(dt);
    }
  }

  void _updateTasks<T extends Task>({
    required double dt,
    required List<T> tasks,
    required Function(T) callback,
  }) {
    final List<T> tasksToRemove = [];

    for (final T task in tasks) {
      if (task.update(dt)) {
        callback(task);
        tasksToRemove.add(task);
      }
    }

    for (final T task in tasksToRemove) {
      tasks.remove(task);
    }
  }
}
