import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Cavalry extends Building {
  Cavalry({
    required super.village,
    required super.level,
  }) : super(
          buildingType: BuildingType.cavalry,
          offset: BuildingType.cavalry.position,
        );
}
