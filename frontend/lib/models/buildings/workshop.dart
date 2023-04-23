import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Workshop extends Building {
  Workshop({
    required super.colony,
    required super.zone,
    required super.level,
  }) : super(
          buildingType: BuildingType.workshop,
          offset: BuildingType.workshop.position,
          workers: 0,
        );
}
