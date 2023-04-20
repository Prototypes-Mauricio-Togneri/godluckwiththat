import 'package:tensionplanet/models/buildings/building.dart';
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
  int freeVillagers;
  final List<Building> buildings;
  final List<Construction> constructions;
  final List<Patch> patches;

  Village({
    required this.name,
    required this.inventory,
    required this.freeVillagers,
    required this.buildings,
    required this.constructions,
    required this.patches,
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
      buildings.add(Building.create(
        village: this,
        buildingType: construction.buildingType,
        level: construction.toLevel,
        patch: _patchForBuilding(construction.buildingType),
      ));
    }
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
