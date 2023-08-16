import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/types/building_type.dart';

class Warehouse extends Building {
  Warehouse({
    required super.colony,
    required super.level,
  }) : super(
          buildingType: BuildingType.warehouse,
          villagers: 0,
        );
}
