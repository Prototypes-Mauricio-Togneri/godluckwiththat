import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Warehouse extends Building {
  Warehouse({
    required super.colony,
    required super.zone,
    required super.level,
  }) : super(
          buildingType: BuildingType.warehouse,
          offset: BuildingType.warehouse.position,
          workers: 0,
        );
}
