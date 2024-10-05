import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/types/building_type.dart';

class Market extends Building {
  Market({
    required super.colony,
    required super.level,
  }) : super(
          buildingType: BuildingType.market,
        );
}
