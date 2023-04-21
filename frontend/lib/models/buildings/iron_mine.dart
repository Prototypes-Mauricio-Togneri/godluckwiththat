import 'package:tensionplanet/models/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class IronMine extends Producer {
  IronMine({
    required super.village,
    required super.patch,
    required super.level,
    required super.villagers,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.iron_mine,
          resourceType: ResourceType.iron,
        );
}
