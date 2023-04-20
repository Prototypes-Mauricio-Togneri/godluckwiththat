import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/models/buildings/farm.dart';
import 'package:tensionplanet/models/buildings/headquarters.dart';
import 'package:tensionplanet/models/construction.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/producer_location.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Village {
  final String name;
  final Inventory inventory;
  final List<Building> buildings;
  final List<Construction> constructions;
  int freeVillagers;

  Village({
    required this.name,
    required this.inventory,
    required this.buildings,
    required this.freeVillagers,
    required this.constructions,
  });

  void update(double dt) {
    for (final Construction construction in constructions) {
      construction.update(dt);
    }

    for (final Building building in buildings) {
      building.update(dt);
    }
  }

  Building? getBuilding(BuildingType buildingType) {
    for (final Building building in buildings) {
      if (building.buildingType == buildingType) {
        return building;
      }
    }

    return null;
  }

  void addBuildings(List<Building> list) {
    buildings.addAll(list);
  }

  void addResource(ResourceType resourceType) {
    inventory.addResource(Resource(resourceType, 1));
  }

  void onStartConstruction(Construction construction) {
    constructions.add(construction);
  }

  void onConstructionCompleted(Construction construction) {
    constructions.remove(construction);
    final Building? building = getBuilding(construction.buildingType);

    if (building != null) {
      building.level = construction.toLevel;
    } else {
      switch (construction.buildingType) {
        case BuildingType.headquarters:
          buildings.add(Headquarters(
            village: this,
            level: 1,
          ));
          break;
        case BuildingType.house:
          // TODO: Handle this case.
          break;
        case BuildingType.market:
          // TODO: Handle this case.
          break;
        case BuildingType.warehouse:
          // TODO: Handle this case.
          break;
        case BuildingType.farm:
          buildings.add(Farm(
            village: this,
            level: 1,
            productionTime: construction.buildingType.productionTime(1),
            location: ProducerLocation.north,
          ));
          break;
        case BuildingType.woodcutter:
          // TODO: Handle this case.
          break;
        case BuildingType.quarry:
          // TODO: Handle this case.
          break;
        case BuildingType.copper_mine:
          // TODO: Handle this case.
          break;
        case BuildingType.iron_mine:
          // TODO: Handle this case.
          break;
        case BuildingType.gold_mine:
          // TODO: Handle this case.
          break;
        case BuildingType.barracks:
          // TODO: Handle this case.
          break;
        case BuildingType.archery:
          // TODO: Handle this case.
          break;
        case BuildingType.cavalry:
          // TODO: Handle this case.
          break;
        case BuildingType.workshop:
          // TODO: Handle this case.
          break;
        case BuildingType.fortress:
          // TODO: Handle this case.
          break;
      }
    }
  }
}
