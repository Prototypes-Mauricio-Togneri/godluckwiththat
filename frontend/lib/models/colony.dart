import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/json/json_colony.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/player.dart';
import 'package:gatewayguardians/models/resource.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Colony {
  final Player owner;
  final Inventory inventory;
  int freeVillagers;

  Colony({
    required this.owner,
    required this.inventory,
    required this.freeVillagers,
  });

  bool get hasFreeVillagers => freeVillagers > 0;

  bool get isOwn => owner.isOwn;

  // resources generated per turn
  int productionOf(ResourceType resourceType) {
    const int total = 0;

    /*for (final Zone zone in zones) {
      if ((zone.building is Producer) &&
          (zone.building?.buildingType.produces == resourceType)) {
        total += (zone.building as Producer).resourcesPerTurn;
      }
    }*/

    return total;
  }

  int get populationLimit {
    const int total = 0;

    /*for (final Zone zone in zones) {
      if (zone.building?.buildingType == BuildingType.house) {
        total += Constants.HOUSE_POPULATION;
      }
    }*/

    return total + Constants.HEADQUARTERS_POPULATION;
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
