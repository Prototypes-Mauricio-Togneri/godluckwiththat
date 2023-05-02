import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Farm extends Producer {
  Farm({
    required super.level,
    required super.workers,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.farm,
          resourceType: ResourceType.food,
        );
}
