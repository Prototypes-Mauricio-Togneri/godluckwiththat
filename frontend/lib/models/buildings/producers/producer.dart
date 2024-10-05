import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/types/resource_type.dart';

abstract class Producer extends Building {
  final ResourceType resourceType;
  final double productionRate;
  int workers;

  Producer({
    required this.resourceType,
    required this.productionRate,
    required this.workers,
    required super.buildingType,
    required super.colony,
    required super.level,
  });

  bool get hasWorkers => workers > 0;

  int get maxWorkersCapacity => level * Constants.BUILDING_CAPACITY_PER_LEVEL;

  bool get canAddWorkers =>
      colony.hasFreeWorkers && (maxWorkersCapacity > workers);

  bool get canRemoveWorkers => hasWorkers;

  double get production => productionRate * workers;

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

  void addWorkers() {
    if (canAddWorkers) {
      workers += colony.removeFreeWorkers(1);
    }
  }

  void removeWorkers() {
    if (hasWorkers) {
      workers -= colony.addFreeWorkers(1);
    }
  }

  @override
  void destroy() {
    colony.addFreeWorkers(workers);
  }
}
