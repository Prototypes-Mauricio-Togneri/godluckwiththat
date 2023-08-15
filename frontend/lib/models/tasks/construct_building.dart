import 'package:godluckwiththat/models/tasks/task.dart';
import 'package:godluckwiththat/types/building_type.dart';

class ConstructBuildingTask extends Task {
  final BuildingType buildingType;

  ConstructBuildingTask(super.cost, this.buildingType);
}
