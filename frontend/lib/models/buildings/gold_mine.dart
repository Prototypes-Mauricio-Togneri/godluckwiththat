import 'package:tensionplanet/models/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class GoldMine extends Producer {
  GoldMine({
    required super.colony,
    required super.zone,
    required super.patch,
    required super.level,
    required super.workers,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.gold_mine,
          resourceType: ResourceType.gold,
        );
}
