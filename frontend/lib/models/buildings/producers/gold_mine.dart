import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class GoldMine extends Producer {
  GoldMine({
    required super.colony,
    required super.level,
    required super.workers,
  }) : super(
          buildingType: BuildingType.goldMine,
          resourceType: ResourceType.gold,
          productionRate: Constants.GOLD_MINE_PRODUCTION_RATE,
        );
}
