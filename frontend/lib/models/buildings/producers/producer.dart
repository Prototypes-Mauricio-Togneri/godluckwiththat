import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Producer extends Building {
  final ResourceType resourceType;

  Producer({
    required BuildingType buildingType,
    required this.resourceType,
    required super.level,
    required super.villagers,
  }) : super(buildingType: buildingType);

  double get production => 1.1;
}
