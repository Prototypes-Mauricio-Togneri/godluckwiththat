import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class House extends Building {
  House({
    required super.colony,
    required super.zone,
    required super.level,
  }) : super(
          buildingType: BuildingType.house,
          workers: 0,
        );
}
