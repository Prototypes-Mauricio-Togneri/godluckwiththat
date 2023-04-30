import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Archery extends Building {
  Archery({
    required super.colony,
    required super.zone,
    required super.location,
    required super.level,
  }) : super(
          buildingType: BuildingType.archery,
          workers: 0,
        );
}
