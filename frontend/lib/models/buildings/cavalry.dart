import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Cavalry extends Building {
  Cavalry({
    required super.level,
  }) : super(
          buildingType: BuildingType.cavalry,
          workers: 0,
        );
}
