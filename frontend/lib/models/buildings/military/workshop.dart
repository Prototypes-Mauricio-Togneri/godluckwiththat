import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Workshop extends Building {
  Workshop({
    required super.level,
  }) : super(
          buildingType: BuildingType.workshop,
          villagers: 0,
        );
}
