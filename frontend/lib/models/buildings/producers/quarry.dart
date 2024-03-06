import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Quarry extends Producer {
  Quarry({
    required super.colony,
    required super.level,
    required super.villagers,
  }) : super(
          buildingType: BuildingType.quarry,
          resourceType: ResourceType.stone,
          productionRate: Constants.QUARRY_PRODUCTION_RATE,
        );
}
