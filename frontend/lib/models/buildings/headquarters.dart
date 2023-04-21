import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Headquarters extends Building {
  Headquarters({
    required super.village,
    required super.level,
    required super.villagers,
  }) : super(
          buildingType: BuildingType.headquarters,
          offset: BuildingType.headquarters.position,
        );
}
