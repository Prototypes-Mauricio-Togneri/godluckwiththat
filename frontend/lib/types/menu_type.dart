import 'package:godluckwiththat/models/tasks/exploration_task.dart';
import 'package:godluckwiththat/types/patch_type.dart';

enum MenuType {
  headquarters,
  water,
  food,
  wood,
  stone,
  faith,
  warehouse,
  market,
  research;

  static MenuType fromExploration(ExplorationTask task) {
    switch (task.patchType) {
      case PatchType.water:
        return water;
      case PatchType.food:
        return food;
      case PatchType.wood:
        return wood;
      case PatchType.stone:
        return stone;
    }
  }
}
