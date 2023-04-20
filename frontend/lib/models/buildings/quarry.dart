import 'package:tensionplanet/models/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Quarry extends Producer {
  Quarry({
    required super.village,
    required super.level,
    required super.productionTime,
    required super.location,
  }) : super(
          buildingType: BuildingType.quarry,
          resourceType: ResourceType.stone,
        );
}
