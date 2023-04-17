import 'package:tensionplanet/components/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Quarry extends Producer {
  Quarry()
      : super(
          buildingType: BuildingType.quarry,
          resourceType: ResourceType.stone,
          productionTime: 10,
        );
}
