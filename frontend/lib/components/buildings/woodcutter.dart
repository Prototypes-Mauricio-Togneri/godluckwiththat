import 'package:tensionplanet/components/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Woodcutter extends Producer {
  Woodcutter()
      : super(
          buildingType: BuildingType.woodcutter,
          resourceType: ResourceType.wood,
          productionTime: 5,
        );
}
