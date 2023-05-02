import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Warehouse extends Building {
  Warehouse({
    required super.level,
  }) : super(
          buildingType: BuildingType.warehouse,
          workers: 0,
        );
}
