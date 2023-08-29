import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/tasks/task.dart';

class UpgradeBuildingTask extends Task {
  final Building building;

  UpgradeBuildingTask({
    required this.building,
    required super.cost,
  }) : super(duration: cost.duration);
}
