import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Woodcutter extends Producer {
  Woodcutter({
    required super.level,
    required super.workers,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.woodcutter,
          resourceType: ResourceType.wood,
        );
}
