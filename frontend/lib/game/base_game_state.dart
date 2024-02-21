import 'package:dafluta/dafluta.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/woodcutter.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/inventory/resource_inventory.dart';
import 'package:godluckwiththat/models/inventory/unit_inventory.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/types/unit_type.dart';

class BaseGameState extends BaseState {
  late final Colony colony;

  BaseGameState() {
    colony = Colony(
      resourceInventory: ResourceInventory.create(
        resources: {
          ResourceType.food: 100,
          ResourceType.wood: 50,
          ResourceType.stone: 30,
        },
        capacities: {
          ResourceType.food: 100,
          ResourceType.wood: 100,
          ResourceType.stone: 100,
        },
      ),
      unitInventory: UnitInventory.create(
        units: {
          UnitType.villager: 5,
        },
        capacities: {
          UnitType.villager: 10,
        },
      ),
      buildings: [],
      daysElapsed: 0,
      freeVillagers: 5,
    );

    colony.addBuildings([
      Headquarters(
        colony: colony,
        level: 1,
      ),
      Farm(
        colony: colony,
        level: 1,
        villagers: 0,
      ),
      Woodcutter(
        colony: colony,
        level: 1,
        villagers: 0,
      ),
    ]);
  }

  void update(double dt) {
    colony.update(dt);
  }
}
