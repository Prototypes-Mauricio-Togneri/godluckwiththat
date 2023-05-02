import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Headquarters extends Building {
  Headquarters({
    required super.level,
    required super.workers,
  }) : super(
          buildingType: BuildingType.headquarters,
        );
}
