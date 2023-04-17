import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Barracks extends Building {
  Barracks({required super.level})
      : super(
          buildingType: BuildingType.barracks,
        );
}
