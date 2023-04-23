import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/construction.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/patch_location.dart';

class Zone {
  final Colony colony;
  final List<Building> buildings;
  final List<Construction> constructions;
  final List<Patch> patches;
  final int maxBuildings;

  Zone({
    required this.colony,
    required this.buildings,
    required this.constructions,
    required this.patches,
    required this.maxBuildings,
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
        colony: colony,
        zone: this,
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
