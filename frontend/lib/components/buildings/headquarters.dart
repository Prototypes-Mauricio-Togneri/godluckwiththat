import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Headquarters extends Building {
  Headquarters({required super.level})
      : super(
          buildingType: BuildingType.headquarters,
        );
}
