import 'package:godluckwiththat/models/tasks/task.dart';
import 'package:godluckwiththat/types/building_type.dart';

class ConstructBuildingTask extends Task {
  final BuildingType buildingType;

  ConstructBuildingTask({
    required super.cost,
    required this.buildingType,
  });
}
