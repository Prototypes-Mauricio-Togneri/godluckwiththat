import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

abstract class Producer extends Building {
  final ResourceType resourceType;
  int resourcesLeft;

  Producer({
    required BuildingType buildingType,
    required this.resourceType,
    required this.resourcesLeft,
    required super.colony,
    required super.level,
    required super.villagers,
  }) : super(buildingType: buildingType);

  double get production => productionRate * villagers;

  double get productionRate;
}
