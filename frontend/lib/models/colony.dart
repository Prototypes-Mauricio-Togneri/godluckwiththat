import 'package:flutter/painting.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/color_extension.dart';
import 'package:gatewayguardians/json/json_colony.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/buildings/house.dart';
import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/models/resource.dart';
import 'package:gatewayguardians/models/zone.dart';
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

  // resources generated per minute
  int productionOf(ResourceType resourceType) {
    double total = 0;

    for (final Zone zone in zones) {
      for (final Patch patch in zone.patches) {
        if (patch.hasBuilding) {
          final Building building = patch.building!;

          if ((building is Producer) &&
              (building.resourceType == resourceType)) {
            total += building.productionPerMinute;
          }
        }
      }
    }

    return total.truncate();
  }

  int get populationLimit {
    int total = 0;

    for (final Zone zone in zones) {
      for (final Patch patch in zone.patches) {
        if (patch.hasBuilding) {
          final Building building = patch.building!;

          if (building is House) {
            total += Constants.HOUSE_POPULATION;
          }
        }
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

  void addResource(ResourceType resourceType) {
    inventory.addResource(Resource(resourceType, 1));
  }

  JsonColony get json => JsonColony(
        owner: owner,
        color: color.toHex(),
        inventory: inventory.json,
        freeVillagers: freeVillagers,
      );
}
