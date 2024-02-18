import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/models/buildings/trainers/house.dart';
import 'package:godluckwiththat/models/buildings/trainers/trainer.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Colony {
  final Inventory inventory;
  final Map<BuildingType, Building> buildings;
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

  List<Producer> get producers => buildings.values
      .where((b) => b.isProducer)
      .map((b) => b as Producer)
      .toList();

  List<Trainer> get trainers => buildings.values
      .where((b) => b.isTrainer)
      .map((b) => b as Trainer)
      .toList();

  T getBuilding<T extends Building>(BuildingType type) => buildings[type]! as T;

  void update(double dt) {
    daysElapsed += dt;

    for (final Building building in buildings.values) {
      building.update(dt, this);
    }
  }

  double productionOf(ResourceType resourceType) {
    double total = 0;

    for (final Building building in buildings.values) {
      if ((building is Producer) && (building.resourceType == resourceType)) {
        total += building.production;
      }
    }

    return total;
  }

  double outputOf(ResourceType resourceType) => productionOf(resourceType);

  int get populationLimit {
    int total = 0;

    for (final Building building in buildings.values) {
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
    for (final Building building in list) {
      buildings[building.buildingType] = building;
    }
  }

  void removeBuilding(Building building) {
    buildings.remove(building.buildingType);
  }

  /*void _createBuilding({
    required BuildingType buildingType,
    required double resourcesLeft,
  }) {
    buildings.add(Building.create(
      colony: this,
      buildingType: buildingType,
      level: 1,
      villagers: 0,
      resourcesLeft: resourcesLeft,
    ));
  }*/

  void addResource(Resource resource) {
    inventory.addResource(resource);
  }

  void removeResource(Resource resource) {
    inventory.removeResource(resource);
  }

  void addResources(ResourceMap resources) {
    inventory.addResources(resources.resources());
  }

  void removeResources(ResourceMap resources) {
    inventory.removeResources(resources.resources());
  }

  bool hasResource(Resource resource) => inventory.hasResource(resource);

  bool hasResources(ResourceMap resources) => inventory.hasResources(resources);
}
