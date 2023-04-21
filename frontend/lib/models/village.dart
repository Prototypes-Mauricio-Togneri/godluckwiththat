import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/models/buildings/house.dart';
import 'package:tensionplanet/models/buildings/producer.dart';
import 'package:tensionplanet/models/construction.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/patch_location.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Village {
  final String name;
  final Inventory inventory;
  final List<Building> buildings;
  final List<Construction> constructions;
  final List<Patch> patches;
  int freeVillagers;

  Village({
    required this.name,
    required this.inventory,
    required this.freeVillagers,
    required this.buildings,
    required this.constructions,
    required this.patches,
  });

  bool get hasFreeVillagers => freeVillagers > 0;

  int get populationLimit {
    int total = 0;

    for (final Building building in buildings) {
      if (building is House) {
        total += Constants.HOUSE_POPULATION;
      }
    }

    return total + Constants.HEADQUARTERS_POPULATION;
  }

  int removeFreeVillager() {
    freeVillagers--;

    return 1;
  }

  int addFreeVillager() {
    freeVillagers++;

    return 1;
  }

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

  void addResource(ResourceType resourceType) {
    inventory.addResource(Resource(resourceType, 1));
  }

  void onStartConstruction(Construction construction) {
    constructions.add(construction);
  }

  void onConstructionCompleted(Construction construction) {
    constructions.remove(construction);
    final BuildingType buildingType = construction.buildingType;
    final Building? building = getBuilding(buildingType);

    if (building != null) {
      building.level = construction.toLevel;
    } else {
      buildings.add(Building.create(
        village: this,
        buildingType: buildingType,
        level: construction.toLevel,
        workers: 0,
        patch: buildingType.isProducer ? _patchForBuilding(buildingType) : null,
      ));
    }

    GameState.instance.notify();
  }

  Patch patchByLocation(PatchLocation location) {
    for (final Patch patch in patches) {
      if (patch.location == location) {
        return patch;
      }
    }

    throw Exception('Patch not found for $location');
  }

  bool _isPatchAvailable(Patch patch) {
    for (final Building building in buildings) {
      if ((building is Producer) && building.patch == patch) {
        return false;
      }
    }

    return true;
  }

  Patch _patchForBuilding(BuildingType buildingType) {
    for (final Patch patch in patches) {
      if ((patch.resourceType == buildingType.produces) &&
          _isPatchAvailable(patch)) {
        return patch;
      }
    }

    throw Exception('Available patch not found for $buildingType');
  }
}
