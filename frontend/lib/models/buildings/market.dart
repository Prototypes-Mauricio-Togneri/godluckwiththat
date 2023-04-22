import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Market extends Building {
  Market({
    required super.zone,
    required super.level,
  }) : super(
          buildingType: BuildingType.market,
          offset: BuildingType.market.position,
          workers: 0,
        );
}
