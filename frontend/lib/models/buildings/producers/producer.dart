import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

abstract class Producer extends Building {
  final ResourceType resourceType;

  Producer({
    required BuildingType buildingType,
    required this.resourceType,
    required super.colony,
    required super.level,
    required super.villagers,
  }) : super(buildingType: buildingType);

  double get production => productionRate * villagers;

  double get productionRate;

  int get resources => colony.inventory.get(resourceType).toInt();

  int get capacity => level * 100;

  @override
  void update(double dt, Colony colony) {
    super.update(dt, colony);

    if (resources < capacity) {
      final double produced = production * dt;
      colony.addResource(Resource(resourceType, produced));
    }
  }
}
