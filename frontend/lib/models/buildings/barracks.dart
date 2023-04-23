import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Barracks extends Building {
  Barracks({
    required super.colony,
    required super.zone,
    required super.level,
  }) : super(
          buildingType: BuildingType.barracks,
          offset: BuildingType.barracks.position,
          workers: 0,
        );
}
