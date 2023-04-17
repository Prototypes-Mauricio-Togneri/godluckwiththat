import 'package:tensionplanet/components/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class IronMine extends Producer {
  IronMine()
      : super(
          buildingType: BuildingType.iron_mine,
          resourceType: ResourceType.iron,
          productionTime: 15,
        );
}
