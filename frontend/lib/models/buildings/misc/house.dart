import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/types/building_type.dart';

class House extends Building {
  House({
    required super.level,
  }) : super(
          buildingType: BuildingType.house,
          villagers: 0,
        );
}
