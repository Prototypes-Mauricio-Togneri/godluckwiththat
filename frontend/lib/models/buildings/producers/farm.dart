import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Farm extends Producer {
  Farm({
    required super.colony,
    required super.level,
    required super.villagers,
  }) : super(
          buildingType: BuildingType.farm,
          resourceType: ResourceType.food,
        );

  @override
  double get productionRate => Constants.FARM_PRODUCTION_RATE;
}
