import 'package:tensionplanet/components/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Farm extends Producer {
  Farm()
      : super(
          buildingType: BuildingType.farm,
          resourceType: ResourceType.food,
          productionTime: 3,
        );
}
