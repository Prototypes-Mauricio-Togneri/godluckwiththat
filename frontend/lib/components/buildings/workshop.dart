import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Workshop extends Building {
  Workshop({
    required super.village,
    required super.level,
  }) : super(
          buildingType: BuildingType.workshop,
          offset: BuildingType.workshop.position,
        );
}
