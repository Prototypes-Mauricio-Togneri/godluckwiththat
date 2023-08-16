import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Woodcutter extends Producer {
  Woodcutter({
    required super.colony,
    required super.level,
    required super.villagers,
    required super.resourcesLeft,
  }) : super(
          buildingType: BuildingType.woodcutter,
          resourceType: ResourceType.wood,
        );

  @override
  double get productionRate => Constants.WOODCUTTER_PRODUCTION_RATE;
}
