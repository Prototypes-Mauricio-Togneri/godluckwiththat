import 'package:tensionplanet/components/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class IronMine extends Producer {
  IronMine({
    required super.level,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.iron_mine,
          resourceType: ResourceType.iron,
        );
}
