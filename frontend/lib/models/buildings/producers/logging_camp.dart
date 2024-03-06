import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class LoggingCamp extends Producer {
  LoggingCamp({
    required super.colony,
    required super.level,
    required super.villagers,
  }) : super(
          buildingType: BuildingType.loggingCamp,
          resourceType: ResourceType.wood,
          productionRate: Constants.LOGGING_CAMP_PRODUCTION_RATE,
        );
}
