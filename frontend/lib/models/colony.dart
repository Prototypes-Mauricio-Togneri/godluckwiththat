import 'package:flutter/painting.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/color_extension.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/json/json_colony.dart';
import 'package:gatewayguardians/models/buildings/producers/producer.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/resource.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Colony {
  final String owner;
  final Color color;
  final Inventory inventory;
  final List<Zone> zones;
  int freeVillagers;

  Colony({
    required this.owner,
    required this.color,
    required this.inventory,
    required this.zones,
    required this.freeVillagers,
  });

  bool get hasFreeVillagers => freeVillagers > 0;

  bool get isOwned => owner == Constants.PLAYER_OWNER;

  // resources generated per turn
  int productionOf(ResourceType resourceType) {
    int total = 0;

    for (final Zone zone in zones) {
      if ((zone.building is Producer) &&
          (zone.building?.buildingType.produces == resourceType)) {
        total += (zone.building as Producer).resourcesPerTurn;
      }
    }

    return total;
  }

  int get populationLimit {
    int total = 0;

    for (final Zone zone in zones) {
      if (zone.building?.buildingType == BuildingType.house) {
        total += Constants.HOUSE_POPULATION;
      }
    }

    return total + Constants.HEADQUARTERS_POPULATION;
  }

  Zone? zoneById(String id) {
    for (final Zone zone in zones) {
      if (zone.id == id) {
        return zone;
      }
    }

    return null;
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
        owner: owner,
        color: color.toHex(),
        inventory: inventory.json,
        freeVillagers: freeVillagers,
      );
}
