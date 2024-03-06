import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/types/resource_type.dart';

abstract class Producer extends Building {
  final ResourceType resourceType;
  final double productionRate;
  int villagers;

  Producer({
    required this.resourceType,
    required this.productionRate,
    required this.villagers,
    required super.buildingType,
    required super.colony,
    required super.level,
  });

  bool get hasVillagers => villagers > 0;

  int get maxWorkersCapacity => level * Constants.BUILDING_CAPACITY_PER_LEVEL;

  bool get canAddVillagers =>
      colony.hasFreeVillagers && (maxWorkersCapacity > villagers);

  bool get canRemoveVillagers => hasVillagers;

  double get production => productionRate * villagers;

  bool get canProduce => colony.resourceInventory.canProduce(resourceType);

  @override
  bool get isProducer => true;

  @override
  void update(double dt) {
    super.update(dt);

    if (canProduce) {
      final double produced = production * dt;
      colony.resourceInventory.add(resourceType, produced);
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
