import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Archery extends Building {
  Archery({
    required super.colony,
    required super.zone,
    required super.level,
  }) : super(
          buildingType: BuildingType.archery,
          offset: BuildingType.archery.position,
          workers: 0,
        );
}
