import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Field extends Producer {
  Field({
    required super.level,
    required super.villagers,
    required super.resourcesLeft,
  }) : super(
          buildingType: BuildingType.field,
          resourceType: ResourceType.food,
        );
}
