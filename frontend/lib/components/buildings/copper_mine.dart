import 'package:tensionplanet/components/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class CopperMine extends Producer {
  CopperMine()
      : super(
          buildingType: BuildingType.copper_mine,
          resourceType: ResourceType.copper,
          productionTime: 15,
        );
}
