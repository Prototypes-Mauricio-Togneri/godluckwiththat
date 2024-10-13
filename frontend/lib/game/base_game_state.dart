import 'package:dafluta/dafluta.dart';
import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/building.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/models/buildings/passive/storehouse.dart';
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
        ResourceType.food: 50,
        ResourceType.wood: 50,
        ResourceType.stone: 50,
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
      resourcesCapacity: 0,
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
    colony.resourcesCapacity = _resourcesCapacity(colony.buildings);
  }

  int _territorySlotsUsed(Map<BuildingType, Building> buildings) {
    int result = 0;

    for (final Building building in buildings.values) {
      if (building is Headquarters) {
        result += 1;
      } else {
        result += building.level;
      }
    }

    return result;
  }

  int _resourcesCapacity(Map<BuildingType, Building> buildings) {
    int result = Constants.BASE_RESOURCE_CAPACITY;

    for (final Building building in buildings.values) {
      if (building is Storehouse) {
        result += building.level * Constants.RESOURCE_CAPACITY_PER_LEVEL;
      }
    }

    return result;
  }

  void update(double dt) {
    colony.update(dt);
  }
}
