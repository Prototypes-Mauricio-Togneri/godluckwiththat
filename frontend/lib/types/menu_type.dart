import 'package:godluckwiththat/models/tasks/construction_task.dart';
import 'package:godluckwiththat/models/tasks/exploration_task.dart';
import 'package:godluckwiththat/types/building_type.dart';
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

  static MenuType fromConstruction(ConstructionTask task) {
    switch (task.buildingType) {
      case BuildingType.headquarters:
      case BuildingType.house:
        return headquarters;
      case BuildingType.warehouse:
        return warehouse;
      case BuildingType.well:
        return water;
      case BuildingType.farm:
        return food;
      case BuildingType.woodcutter:
        return wood;
      case BuildingType.quarry:
        return stone;
    }
  }
}
