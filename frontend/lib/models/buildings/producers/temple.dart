import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Temple extends Producer {
  Temple({
    required super.colony,
    required super.level,
    required super.workers,
  }) : super(
          buildingType: BuildingType.temple,
          resourceType: ResourceType.faith,
          productionRate: Constants.TEMPLE_PRODUCTION_RATE,
        );
}
