import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Woodcutter extends Producer {
  Woodcutter({
    required super.level,
    required super.villagers,
  }) : super(
          buildingType: BuildingType.woodcutter,
          resourceType: ResourceType.wood,
        );
}
