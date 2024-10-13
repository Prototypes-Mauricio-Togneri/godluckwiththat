import 'package:dafluta/dafluta.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/inventory/resource_inventory.dart';
import 'package:godluckwiththat/models/inventory/unit_inventory.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/headquarters_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/types/unit_type.dart';

class BaseGameState extends BaseState {
  late final Colony colony;

  BaseGameState() {
    colony = Colony(
      resources: ResourceInventory({
        ResourceType.food: 500,
        ResourceType.wood: 500,
        ResourceType.stone: 500,
        ResourceType.copper: 0,
        ResourceType.iron: 0,
        ResourceType.gold: 0,
        ResourceType.faith: 0,
        ResourceType.knowledge: 0,
      }),
      units: UnitInventory({
        UnitType.worker: 5,
      }),
      buildings: {},
      pastEvents: [],
      futureEvents: [],
      timeElapsed: 0,
      freeWorkers: 5,
      territorySlotsUsed: 0,
      warehouseCapacity: 100,
    );

    colony.buildings.addAll({
      BuildingType.headquarters: Headquarters(
        colony: colony,
        level: 1,
        type: HeadquartersType.camp,
      ),
      /*BuildingType.house: House(
        colony: colony,
        level: 1,
      ),
      BuildingType.academy: Academy(
        colony: colony,
        level: 1,
        workers: 1,
      ),
      BuildingType.farm: Farm(
        colony: colony,
        level: 1,
        workers: 2,
      ),
      BuildingType.woodcutter: Woodcutter(
        colony: colony,
        level: 1,
        workers: 1,
      ),
      BuildingType.quarry: Quarry(
        colony: colony,
        level: 1,
        workers: 1,
      ),
      BuildingType.copperMine: CopperMine(
        colony: colony,
        level: 1,
        workers: 1,
      ),
      BuildingType.ironMine: IronMine(
        colony: colony,
        level: 1,
        workers: 1,
      ),
      BuildingType.goldMine: GoldMine(
        colony: colony,
        level: 1,
        workers: 1,
      ),*/
    });
    colony.territorySlotsUsed = _territorySlotsUsed(colony.buildings);
  }

  int _territorySlotsUsed(Map<BuildingType, Building> buildings) {
    int slots = 0;

    for (final Building building in buildings.values) {
      slots += building.level;
    }

    return slots;
  }

  void update(double dt) {
    colony.update(dt);
  }
}
