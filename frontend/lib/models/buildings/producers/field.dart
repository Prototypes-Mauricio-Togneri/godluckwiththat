import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Field extends Producer {
  Field({
    required super.colony,
    required super.level,
    required super.villagers,
    required super.resourcesLeft,
  }) : super(
          buildingType: BuildingType.field,
          resourceType: ResourceType.food,
        );

  @override
  double get productionRate => Constants.FIELD_PRODUCTION_RATE;
}
