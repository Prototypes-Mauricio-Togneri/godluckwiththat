import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class IronMine extends Producer {
  IronMine({
    required super.colony,
    required super.zone,
    required super.level,
    required super.workers,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.iron_mine,
          resourceType: ResourceType.iron,
        );
}
