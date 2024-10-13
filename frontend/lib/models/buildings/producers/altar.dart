import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Altar extends Producer {
  Altar({
    required super.colony,
    required super.level,
  }) : super(
          workers: 0,
          buildingType: BuildingType.altar,
          resourceType: ResourceType.faith,
          productionRate: Constants.ALTAR_PRODUCTION_RATE,
          acceptsWorkers: false,
        );

  @override
  double get production => productionRate * level;
}
