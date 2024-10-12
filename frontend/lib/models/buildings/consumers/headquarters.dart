import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/consumers/consumer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/headquarters_type.dart';
import 'package:godluckwiththat/types/unit_type.dart';

class Headquarters extends Consumer {
  HeadquartersType type;

  Headquarters({
    required super.colony,
    required super.level,
    required this.type,
  }) : super(
          buildingType: BuildingType.headquarters,
          unitType: UnitType.worker,
        );

  @override
  ResourceMap get trainingCost => UnitType.worker.cost;

  ResourceMap get improveCost => type.next!.cost;

  bool get canImprove => colony.resources.hasItems(improveCost);

  void improve() {
    if (canImprove) {
      type = type.next!;
      colony.resources.removeItems(improveCost);
      colony.notify();
    }
  }

  @override
  void trainUnit() {
    colony.createWorker();
  }
}
