import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Academy extends Producer {
  Academy({
    required super.colony,
    required super.level,
    required super.workers,
  }) : super(
          buildingType: BuildingType.academy,
          resourceType: ResourceType.knowledge,
          productionRate: Constants.ACADEMY_PRODUCTION_RATE,
        );
}
