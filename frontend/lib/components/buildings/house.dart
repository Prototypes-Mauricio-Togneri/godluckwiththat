import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class House extends Building {
  House({required super.level})
      : super(
          buildingType: BuildingType.house,
          offset: BuildingType.house.position,
        );
}
