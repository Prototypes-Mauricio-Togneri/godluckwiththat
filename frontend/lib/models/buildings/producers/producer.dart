import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/resource_type.dart';

abstract class Producer extends Building {
  final ResourceType resourceType;
  int villagers;

  Producer({
    required this.resourceType,
    required this.villagers,
    required super.buildingType,
    required super.colony,
    required super.level,
  });

  bool get hasVillagers => villagers > 0;

  bool get canHoldMoreVillagers => maxCapacity > villagers;

  bool get canAddVillagers => colony.hasFreeVillagers && canHoldMoreVillagers;

  bool get canRemoveVillagers => hasVillagers;

  double get production => productionRate * villagers;

  double get productionRate;

  int get resources => colony.inventory.get(resourceType).toInt();

  int get capacity => level * 100;

  @override
  bool get isProducer => true;

  @override
  void update(double dt, Colony colony) {
    super.update(dt, colony);

    if (resources < capacity) {
      final double produced = production * dt;
      colony.inventory.addResource(Resource(resourceType, produced));
    }
  }

  void addVillager() {
    if (canAddVillagers) {
      villagers += colony.removeFreeVillagers(1);
    }
  }

  void removeVillagers() {
    if (hasVillagers) {
      villagers -= colony.addFreeVillagers(1);
    }
  }

  @override
  void destroy() {
    colony.addFreeVillagers(villagers);
  }
}
