import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/models/buildings/trainers/house.dart';
import 'package:godluckwiththat/models/buildings/trainers/trainer.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Colony {
  final Inventory inventory;
  final List<Building> buildings;
  num daysElapsed;
  int freeVillagers;

  Colony({
    required this.inventory,
    required this.buildings,
    required this.daysElapsed,
    required this.freeVillagers,
  });

  int get day => (daysElapsed.toInt()) + 1;

  int get year => (daysElapsed ~/ 365).floor() + 1;

  bool get hasFreeVillagers => freeVillagers > 0;

  List<Producer> get producers =>
      buildings.where((b) => b.isProducer).map((b) => b as Producer).toList();

  List<Trainer> get trainers =>
      buildings.where((b) => b.isTrainer).map((b) => b as Trainer).toList();

  void update(double dt) {
    daysElapsed += dt;

    for (final Building building in buildings) {
      building.update(dt, this);
    }
  }

  double productionOf(ResourceType resourceType) {
    double total = 0;

    for (final Building building in buildings) {
      if ((building is Producer) && (building.resourceType == resourceType)) {
        total += building.production;
      }
    }

    return total;
  }

  double outputOf(ResourceType resourceType) => productionOf(resourceType);

  int get totalPopulation {
    return inventory.get(ResourceType.villager).toInt();
  }

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

  void addBuildings(List<Building> list) {
    buildings.addAll(list);
  }

  void removeBuilding(Building building) {
    buildings.remove(building);
  }
}
