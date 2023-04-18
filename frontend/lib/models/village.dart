import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/resource.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Village {
  final String name;
  final Inventory inventory;
  final List<Building> buildings;
  int freeVillagers;

  Village({
    required this.name,
    required this.inventory,
    required this.buildings,
    required this.freeVillagers,
  });

  void addBuildings(List<Building> list) {
    buildings.addAll(list);
  }

  void addResource(ResourceType resourceType) {
    inventory.addResource(Resource(resourceType, 1));
  }
}
