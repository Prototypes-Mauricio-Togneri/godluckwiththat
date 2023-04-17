import 'package:tensionplanet/components/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Farm extends Producer {
  Farm({
    required super.level,
    required super.productionTime,
  })
      : super(
          buildingType: BuildingType.farm,
          resourceType: ResourceType.food,
        );
}
