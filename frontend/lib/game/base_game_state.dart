import 'package:dafluta/dafluta.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/woodcutter.dart';
import 'package:godluckwiththat/models/buildings/trainers/house.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/inventory.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class BaseGameState extends BaseState {
  late final Colony colony;

  BaseGameState() {
    colony = Colony(
      inventory: Inventory.create(
        resources: {
          ResourceType.villager: 5,
          ResourceType.water: 10,
          ResourceType.food: 20,
          ResourceType.wood: 300,
          ResourceType.stone: 40,
        },
        capacities: {
          ResourceType.villager: 10,
          ResourceType.water: 100,
          ResourceType.food: 100,
          ResourceType.wood: 100,
          ResourceType.stone: 100,
        },
      ),
      buildings: [],
      daysElapsed: 0,
      freeVillagers: 5,
    );

    colony.addBuildings([
      House(
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
