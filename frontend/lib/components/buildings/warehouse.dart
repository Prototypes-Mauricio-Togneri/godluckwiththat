import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Warehouse extends Building {
  Warehouse({
    required super.village,
    required super.level,
  }) : super(
          buildingType: BuildingType.warehouse,
          offset: BuildingType.warehouse.position,
        );
}
