import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Fortress extends Building {
  Fortress({
    required super.colony,
    required super.zone,
    required super.level,
  }) : super(
          buildingType: BuildingType.fortress,
          offset: BuildingType.fortress.position,
          workers: 0,
        );
}
