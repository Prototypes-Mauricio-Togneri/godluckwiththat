import 'package:tensionplanet/models/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class GoldMine extends Producer {
  GoldMine({
    required super.village,
    required super.level,
    required super.productionTime,
    required super.location,
  }) : super(
          buildingType: BuildingType.gold_mine,
          resourceType: ResourceType.gold,
        );
}
