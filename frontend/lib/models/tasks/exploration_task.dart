import 'package:godluckwiththat/models/tasks/task.dart';
import 'package:godluckwiththat/types/patch_type.dart';

class ExplorationTask extends Task {
  final PatchType patchType;
  final int days;

  ExplorationTask({
    required super.villagers,
    required this.patchType,
    required this.days,
  }) : super(
          cost: {},
          duration: days.toDouble(),
        );

  int get amount => villagers * days * 50;
}
