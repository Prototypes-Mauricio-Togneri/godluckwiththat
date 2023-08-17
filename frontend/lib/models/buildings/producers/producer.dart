import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/resource.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

abstract class Producer extends Building {
  final ResourceType resourceType;
  double resourcesLeft;

  Producer({
    required BuildingType buildingType,
    required this.resourceType,
    required this.resourcesLeft,
    required super.colony,
    required super.level,
    required super.villagers,
  }) : super(buildingType: buildingType);

  bool get hasResourcesLeft => resourcesLeft > 1;

  double get production => hasResourcesLeft ? (productionRate * villagers) : 0;

  double get productionRate;

  @override
  void update(double dt, Colony colony) {
    super.update(dt, colony);

    if (hasResourcesLeft) {
      final double produced = production * dt;
      resourcesLeft -= produced;
      colony.addResource(Resource(resourceType, produced));
    }
  }
}
