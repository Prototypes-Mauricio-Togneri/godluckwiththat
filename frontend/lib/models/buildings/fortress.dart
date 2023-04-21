import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Fortress extends Building {
  Fortress({
    required super.village,
    required super.level,
  }) : super(
          buildingType: BuildingType.fortress,
          offset: BuildingType.fortress.position,
          villagers: 0,
        );
}
