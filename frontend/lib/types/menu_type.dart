import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/patch_type.dart';

enum MenuType {
  headquarters,
  food,
  wood,
  water,
  stone,
  faith,
  warehouse,
  market,
  research;

  static MenuType fromPatchType(PatchType patchType) {
    switch (patchType) {
      case PatchType.food:
        return food;
      case PatchType.wood:
        return wood;
      case PatchType.water:
        return water;
      case PatchType.stone:
        return stone;
    }
  }

  static MenuType fromBuildingType(BuildingType buildingType) {
    switch (buildingType) {
      case BuildingType.headquarters:
      case BuildingType.house:
        return headquarters;
      case BuildingType.warehouse:
        return warehouse;
      case BuildingType.farm:
        return food;
      case BuildingType.woodcutter:
        return wood;
      case BuildingType.well:
        return water;
      case BuildingType.quarry:
        return stone;
    }
  }
}
