import 'package:tensionplanet/models/buildings/producer.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Woodcutter extends Producer {
  Woodcutter({
    required super.village,
    required super.patch,
    required super.level,
    required super.workers,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.woodcutter,
          resourceType: ResourceType.wood,
        );
}
