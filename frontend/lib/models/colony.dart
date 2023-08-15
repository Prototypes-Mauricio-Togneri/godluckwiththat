import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/json/json_colony.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/misc/headquarters.dart';
import 'package:godluckwiththat/models/buildings/misc/house.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Colony {
  final Inventory inventory;
  final List<Building> buildings;
  late final Headquarters headquarters;
  int freeVillagers;

  Colony({
    required this.inventory,
    required this.buildings,
    required this.freeVillagers,
  }) {
    for (final Building building in buildings) {
      if (building is Headquarters) {
        headquarters = building;
      }
    }
  }

  bool get hasFreeVillagers => freeVillagers > 0;

  void update(double dt) {
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

  int get populationLimit {
    int total = 0;

    for (final Building building in buildings) {
      if (building is House) {
        total += Constants.HOUSE_POPULATION;
      }
    }

    return total + Constants.HEADQUARTERS_POPULATION;
  }

  void createVillager() {
    addFreeVillagers(1);
    inventory.addResource(Resource.villager(1));
    print('');
  }

  int addFreeVillagers(int amount) {
    freeVillagers += amount;

    return amount;
  }

  int removeFreeVillagers(int amount) {
    freeVillagers -= amount;

    return amount;
  }

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

  JsonColony get json => JsonColony(
        owner: '',
        color: '',
        inventory: inventory.json,
        freeVillagers: freeVillagers,
      );
}
