import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';

class Market extends Building {
  Market({required super.level})
      : super(
          buildingType: BuildingType.market,
          offset: BuildingType.market.position,
        );
}
