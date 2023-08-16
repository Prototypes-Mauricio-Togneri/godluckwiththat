import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Well extends Producer {
  Well({
    required super.colony,
    required super.level,
    required super.villagers,
    required super.resourcesLeft,
  }) : super(
          buildingType: BuildingType.well,
          resourceType: ResourceType.water,
        );

  @override
  double get productionRate => Constants.WELL_PRODUCTION_RATE;
}
