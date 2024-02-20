import 'package:godluckwiththat/extensions/item_map_extension.dart';
import 'package:godluckwiththat/models/tasks/task.dart';

class CreateVillagerTask extends Task {
  CreateVillagerTask({
    required super.cost,
  }) : super(
          villagers: 1,
          duration: cost.duration * 5,
        );
}
