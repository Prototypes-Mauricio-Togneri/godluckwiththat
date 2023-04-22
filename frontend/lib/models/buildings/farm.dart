import 'package:tensionplanet/models/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Farm extends Producer {
  Farm({
    required super.zone,
    required super.patch,
    required super.level,
    required super.workers,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.farm,
          resourceType: ResourceType.food,
        );
}
