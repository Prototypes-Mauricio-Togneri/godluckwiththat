import 'package:tensionplanet/models/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class CopperMine extends Producer {
  CopperMine({
    required super.village,
    required super.patch,
    required super.level,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.copper_mine,
          resourceType: ResourceType.copper,
        );
}
