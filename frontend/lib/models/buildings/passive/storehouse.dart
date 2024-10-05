import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/types/building_type.dart';

class Storehouse extends Building {
  Storehouse({
    required super.colony,
    required super.level,
  }) : super(
          buildingType: BuildingType.storehouse,
        );
}
