import 'package:dafluta/dafluta.dart';
import 'package:godluckwiththat/models/buildings/consumers/headquarters.dart';
import 'package:godluckwiththat/models/buildings/passive/house.dart';
import 'package:godluckwiththat/models/buildings/producers/academy.dart';
import 'package:godluckwiththat/models/buildings/producers/copper_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/farm.dart';
import 'package:godluckwiththat/models/buildings/producers/gold_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/iron_mine.dart';
import 'package:godluckwiththat/models/buildings/producers/logging_camp.dart';
import 'package:godluckwiththat/models/buildings/producers/quarry.dart';
import 'package:godluckwiththat/models/colony.dart';
import 'package:godluckwiththat/models/events/building_upgraded_event.dart';
import 'package:godluckwiththat/models/events/challenge_result_event.dart';
import 'package:godluckwiththat/models/events/disaster_result_event.dart';
import 'package:godluckwiththat/models/events/population_limit_reached_event.dart';
import 'package:godluckwiththat/models/events/research_completed_event.dart';
import 'package:godluckwiththat/models/events/resource_limit_reached_event.dart';
import 'package:godluckwiththat/models/events/season_change_event.dart';
import 'package:godluckwiththat/models/events/territory_limit_reached_event.dart';
import 'package:godluckwiththat/models/inventory/resource_inventory.dart';
import 'package:godluckwiththat/models/inventory/unit_inventory.dart';
import 'package:godluckwiththat/types/building_type.dart';
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
      buildings: {},
      events: [
        SeasonChangeEvent(),
        DisasterResultEvent(),
        ChallengeResultEvent(),
        BuildingUpgradedEvent(),
        ResearchCompletedEvent(),
        PopulationLimitReachedEvent(),
        TerritoryLimitReachedEvent(),
        ResourceLimitReachedEvent(),
      ],
      timeElapsed: 0,
      freeWorkers: 5,
      territorySlotsUsed: 0,
      warehouseCapacity: 100,
    );

    colony.buildings.addAll({
      BuildingType.headquarters: Headquarters(
        colony: colony,
        level: 1,
      ),
      BuildingType.house: House(
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
      BuildingType.woodcutter: LoggingCamp(
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
      ),
    });
  }

  void update(double dt) {
    colony.update(dt);
  }
}
