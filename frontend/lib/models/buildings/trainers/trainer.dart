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

  int get resources;

  int get capacity;

  bool get canTrain =>
      colony.inventory.get(ResourceType.villager) < colony.populationLimit;

  @override
  bool get isTrainer => true;

  void train() {
    colony.addResource(Resource.one(resourceType));
  }
}
