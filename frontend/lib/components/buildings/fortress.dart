import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Fortress extends Building {
  Fortress({required super.level})
      : super(
          buildingType: BuildingType.fortress,
        );
}
