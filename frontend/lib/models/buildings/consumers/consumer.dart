import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/past_events/population_limit_reached_event.dart';
import 'package:godluckwiththat/types/unit_type.dart';

abstract class Consumer extends Building {
  final UnitType unitType;

  Consumer({
    required this.unitType,
    required super.buildingType,
    required super.colony,
    required super.level,
  });

  ResourceMap get trainingCost;

  bool get canTrain =>
      (colony.totalWorkers < colony.populationLimit) &&
      colony.resources.hasItems(trainingCost);

  @override
  bool get isConsumer => true;

  void train() {
    if (canTrain) {
      trainUnit();

      if (colony.totalWorkers >= colony.populationLimit) {
        colony.addPastEvent(PopulationLimitReachedEvent());
      }

      colony.notify();
    }
  }

  void trainUnit();
}
