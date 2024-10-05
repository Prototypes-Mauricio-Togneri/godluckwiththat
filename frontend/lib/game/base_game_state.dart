import 'package:dafluta/dafluta.dart';
import 'package:godluckwiththat/models/buildings/consumers/town_center.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/logging_camp.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/inventory/resource_inventory.dart';
import 'package:godluckwiththat/models/inventory/unit_inventory.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/types/unit_type.dart';

class BaseGameState extends BaseState {
  late final Colony colony;

  BaseGameState() {
    colony = Colony(
      resources: ResourceInventory({
        ResourceType.food: 80,
        ResourceType.wood: 90,
        ResourceType.stone: 30,
        ResourceType.copper: 20,
        ResourceType.iron: 10,
        ResourceType.gold: 5,
        ResourceType.faith: 130,
        ResourceType.knowledge: 150,
      }),
      units: UnitInventory({
        UnitType.worker: 5,
      }),
      buildings: [],
      timeElapsed: 0,
      freeWorkers: 5,
    );

    colony.addBuildings([
      TownCenter(
        colony: colony,
        level: 1,
      ),
      Farm(
        colony: colony,
        level: 1,
        workers: 2,
      ),
      LoggingCamp(
        colony: colony,
        level: 1,
        workers: 1,
      ),
    ]);
  }

  void update(double dt) {
    colony.update(dt);
  }
}
