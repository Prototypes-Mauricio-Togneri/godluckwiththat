import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/tasks/task.dart';
import 'package:godluckwiththat/types/building_type.dart';

class ConstructionTask extends Task {
  final BuildingType buildingType;
  final double resourcesAmount;

  ConstructionTask({
    required this.buildingType,
    required this.resourcesAmount,
  }) : super(duration: buildingType.initialCost.duration);
}
