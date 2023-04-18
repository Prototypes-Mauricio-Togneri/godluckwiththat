import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Archery extends Building {
  Archery({
    required super.village,
    required super.level,
  }) : super(
          buildingType: BuildingType.archery,
          offset: BuildingType.archery.position,
        );
}
