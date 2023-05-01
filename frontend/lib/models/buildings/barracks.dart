import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Barracks extends Building {
  Barracks({
    required super.colony,
    required super.zone,
    required super.level,
  }) : super(
          buildingType: BuildingType.barracks,
          workers: 0,
        );
}
