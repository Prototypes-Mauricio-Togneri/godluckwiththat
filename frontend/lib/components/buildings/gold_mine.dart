import 'package:tensionplanet/components/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class GoldMine extends Producer {
  GoldMine({
    required super.level,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.gold_mine,
          resourceType: ResourceType.gold,
        );
}
