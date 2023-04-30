import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Workshop extends Building {
  Workshop({
    required super.colony,
    required super.zone,
    required super.location,
    required super.level,
  }) : super(
          buildingType: BuildingType.workshop,
          workers: 0,
        );
}
