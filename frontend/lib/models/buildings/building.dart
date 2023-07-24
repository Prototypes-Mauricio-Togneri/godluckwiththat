import 'package:gatewayguardians/dialog/confirmation_dialog.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/buildings/archery.dart';
import 'package:gatewayguardians/models/buildings/barracks.dart';
import 'package:gatewayguardians/models/buildings/cavalry.dart';
import 'package:gatewayguardians/models/buildings/copper_mine.dart';
import 'package:gatewayguardians/models/buildings/farm.dart';
import 'package:gatewayguardians/models/buildings/fortress.dart';
import 'package:gatewayguardians/models/buildings/gold_mine.dart';
import 'package:gatewayguardians/models/buildings/headquarters.dart';
import 'package:gatewayguardians/models/buildings/house.dart';
import 'package:gatewayguardians/models/buildings/iron_mine.dart';
import 'package:gatewayguardians/models/buildings/quarry.dart';
import 'package:gatewayguardians/models/buildings/warehouse.dart';
import 'package:gatewayguardians/models/buildings/woodcutter.dart';
import 'package:gatewayguardians/models/buildings/workshop.dart';
import 'package:gatewayguardians/types/building_type.dart';

class Building {
  final BuildingType buildingType;
  int level;
  int workers;

  Building({
    required this.buildingType,
    required this.level,
    required this.workers,
  });

  bool get hasWorkers => workers > 0;

  bool get canAddWorkers => level > workers;

  bool get isProducer =>
      (buildingType == BuildingType.farm) ||
      (buildingType == BuildingType.woodcutter) ||
      (buildingType == BuildingType.quarry) ||
      (buildingType == BuildingType.copper_mine) ||
      (buildingType == BuildingType.iron_mine) ||
      (buildingType == BuildingType.gold_mine);

  int get resourcesPerTurn => 10;

  void onUpgrade() {
    //final ResourceMap cost = buildingType.cost(level + 1);
    //colony.inventory.removeResources(cost.resources());
    //level++;
    //GameState.instance.notify();
  }

  void onAddWorker(GameState state) {
    if (state.colony.hasFreeVillagers) {
      workers += state.colony.removeFreeVillager();
      state.notify();
    }
  }

  void onRemoveWorker(GameState state) {
    if (hasWorkers) {
      workers -= state.colony.addFreeVillager();
      state.notify();
    }
  }

  void onDestroy() => ConfirmationDialog.destroyBuilding(onAccept: _destroy);

  void _destroy() => {}; //GameState.instance.onDestroyBuilding(this);

  factory Building.create({
    required BuildingType buildingType,
    required int level,
    required int workers,
  }) {
    switch (buildingType) {
      case BuildingType.headquarters:
        return Headquarters(
          level: level,
          workers: workers,
        );
      case BuildingType.house:
        return House(
          level: level,
        );
      case BuildingType.warehouse:
        return Warehouse(
          level: level,
        );
      case BuildingType.farm:
        return Farm(
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime,
        );
      case BuildingType.woodcutter:
        return Woodcutter(
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime,
        );
      case BuildingType.quarry:
        return Quarry(
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime,
        );
      case BuildingType.copper_mine:
        return CopperMine(
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime,
        );
      case BuildingType.iron_mine:
        return IronMine(
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime,
        );
      case BuildingType.gold_mine:
        return GoldMine(
          level: level,
          workers: workers,
          productionTime: buildingType.productionTime,
        );
      case BuildingType.barracks:
        return Barracks(
          level: level,
        );
      case BuildingType.archery:
        return Archery(
          level: level,
        );
      case BuildingType.cavalry:
        return Cavalry(
          level: level,
        );
      case BuildingType.workshop:
        return Workshop(
          level: level,
        );
      case BuildingType.fortress:
        return Fortress(
          level: level,
        );
    }
  }
}
