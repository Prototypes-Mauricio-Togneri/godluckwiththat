import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class IronMine extends Producer {
  IronMine({
    required super.colony,
    required super.level,
    required super.workers,
  }) : super(
          buildingType: BuildingType.ironMine,
          resourceType: ResourceType.iron,
          productionRate: Constants.IRON_MINE_PRODUCTION_RATE,
        );
}
