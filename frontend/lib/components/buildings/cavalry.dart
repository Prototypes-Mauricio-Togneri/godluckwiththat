import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Cavalry extends Building {
  Cavalry({required super.level})
      : super(
          buildingType: BuildingType.cavalry,
          offset: BuildingType.cavalry.position,
        );
}
