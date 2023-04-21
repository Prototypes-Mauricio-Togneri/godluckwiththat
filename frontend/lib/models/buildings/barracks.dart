import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Barracks extends Building {
  Barracks({
    required super.village,
    required super.level,
  }) : super(
          buildingType: BuildingType.barracks,
          offset: BuildingType.barracks.position,
          workers: 0,
        );
}
