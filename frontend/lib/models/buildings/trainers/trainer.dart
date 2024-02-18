import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/resource_type.dart';

abstract class Trainer extends Building {
  final ResourceType resourceType;

  Trainer({
    required this.resourceType,
    required super.buildingType,
    required super.colony,
    required super.level,
  });

  num get resources => colony.inventory.get(resourceType);

  num get maxResourceCapacity;

  bool get canTrain => colony.totalPopulation < colony.populationLimit;

  @override
  bool get isTrainer => true;

  void train() {
    if (canTrain) {
      colony.inventory.addResource(Resource.one(resourceType));
    }
  }
}
