import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/patch.dart';
import 'package:godluckwiththat/models/tasks/task.dart';
import 'package:godluckwiththat/types/building_type.dart';

class ConstructionTask extends Task {
  final BuildingType buildingType;
  final double resourcesAmount;
  final Patch? patch;

  ConstructionTask({
    required this.buildingType,
    required this.resourcesAmount,
    required this.patch,
  }) : super(
          cost: buildingType.initialCost,
          duration: buildingType.initialCost.duration,
        );

  bool get hasPatch => patch != null;

  factory ConstructionTask.fromPatch(Patch patch) => ConstructionTask(
        buildingType: patch.patchType.buildingType,
        resourcesAmount: patch.amount.toDouble(),
        patch: patch,
      );
}
