import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class CopperMine extends Producer {
  CopperMine({
    required super.colony,
    required super.level,
    required super.workers,
  }) : super(
          buildingType: BuildingType.copperMine,
          resourceType: ResourceType.copper,
          productionRate: Constants.COPPER_MINE_PRODUCTION_RATE,
        );
}
