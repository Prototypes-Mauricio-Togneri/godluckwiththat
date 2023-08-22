import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/tasks/task.dart';
import 'package:godluckwiththat/types/patch_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class ExplorationTask extends Task {
  final PatchType patchType;
  final int villagers;
  final int days;

  ExplorationTask._({
    required super.cost,
    required this.patchType,
    required this.villagers,
    required this.days,
  });

  factory ExplorationTask.create({
    required PatchType patchType,
    required int villagers,
    required int days,
  }) =>
      ExplorationTask._(
        cost: {
          ResourceType.villager: (days * Constants.SECONDS_PER_DAY).toDouble(),
        },
        patchType: patchType,
        villagers: villagers,
        days: days,
      );
}
