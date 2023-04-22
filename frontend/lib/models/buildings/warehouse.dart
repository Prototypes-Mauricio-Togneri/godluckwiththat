import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Warehouse extends Building {
  Warehouse({
    required super.zone,
    required super.level,
  }) : super(
          buildingType: BuildingType.warehouse,
          offset: BuildingType.warehouse.position,
          workers: 0,
        );
}
