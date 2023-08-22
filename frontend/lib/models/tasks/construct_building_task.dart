import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/tasks/task.dart';
import 'package:godluckwiththat/types/building_type.dart';

class ConstructBuildingTask extends Task {
  final BuildingType buildingType;

  ConstructBuildingTask({
    required ResourceMap cost,
    required this.buildingType,
  }) : super(duration: cost.duration);
}
