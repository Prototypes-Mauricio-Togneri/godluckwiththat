import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/models/action.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/buildings/producers/producer.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/resource.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/types/action_type.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/zone_status.dart';

class Zone {
  final String id;
  final List<Tile> tiles;
  final List<Action> actions;
  String? owner;
  Building? building;
  ZoneStatus status;

  Zone({
    required this.id,
    required this.tiles,
    required this.actions,
    required this.owner,
    required this.building,
    required this.status,
  });

  bool get isOwned => owner == Constants.PLAYER_OWNER;

  bool get isNeutral => owner == null;

  bool get isExplored => status == ZoneStatus.explored;

  bool get isUnexplored => status == ZoneStatus.unexplored;

  bool get hasPatch => tiles.any((t) => t.hasPatch);

  bool get hasAction => actions.isNotEmpty;

  bool get hasActionDestroy =>
      actions.isNotEmpty && (actions.first.actionType == ActionType.destroy);

  bool get hasActionLevelUp =>
      actions.isNotEmpty && (actions.first.actionType == ActionType.levelUp);

  ResourceMap get explorationCost => Resource.food(10).map;

  ResourceMap get claimCost => Resource.food(10).map;

  ResourceMap get trainVillagerCost => Resource.food(10).map;

  bool get canBeSelected => tiles.any((tile) => tile.tileType.canSelected);

  bool canBeExplored(Colony colony) {
    if (status == ZoneStatus.explored) {
      /*final List<Zone> neighbors = colony.getAllNeighbors(this);

      for (final Zone zone in neighbors) {
        if (zone.isUnexplored) {
          return true;
        }
      }*/

      return false;
    } else {
      return false;
    }
  }

  bool canBeClaimed(Colony colony) {
    if (status == ZoneStatus.explored) {
      /*final List<Zone> neighbors = colony.getSideNeighbors(this);

      for (final Zone zone in neighbors) {
        if (zone.isOwned) {
          return true;
        }
      }*/

      return false;
    } else {
      return false;
    }
  }

  List<BuildingType> basic() => [
        BuildingType.house,
        BuildingType.warehouse,
      ];

  List<BuildingType> producers() {
    final List<BuildingType> result = [];

    if (tiles.any((t) => t.hasPatchType(PatchType.crop_field))) {
      result.add(BuildingType.farm);
    }

    if (tiles.any((t) => t.hasPatchType(PatchType.forest))) {
      result.add(BuildingType.woodcutter);
    }

    if (tiles.any((t) => t.hasPatchType(PatchType.stone_deposit))) {
      result.add(BuildingType.quarry);
    }

    /*if (patch == PatchType.copper_deposit) {
      result.add(BuildingType.copper_mine);
    }

    if (patch == PatchType.iron_deposit) {
      result.add(BuildingType.iron_mine);
    }

    if (patch == PatchType.gold_deposit) {
      result.add(BuildingType.gold_mine);
    }*/

    return result;
  }

  List<BuildingType> military() => [
        BuildingType.barracks,
        BuildingType.archery,
        BuildingType.cavalry,
        BuildingType.workshop,
        BuildingType.fortress,
      ];

  void update(Colony colony) {
    if (hasAction) {
      final Action action = actions.first;

      if (action.passTurn()) {
        switch (action.actionType) {
          case ActionType.explore:
            /*for (final Zone zone in colony.getAllNeighbors(this)) {
              zone.status = ZoneStatus.explored;
            }*/
            colony.addFreeVillagers(action.villagers);
            actions.removeAt(0);
            break;
          case ActionType.claim:
            colony.addFreeVillagers(action.villagers);
            owner = Constants.PLAYER_OWNER;
            actions.removeAt(0);
            break;
          case ActionType.train:
            colony.addFreeVillagers(1);
            colony.addResource(Resource.villager(1));
            actions.removeAt(0);
            break;
          case ActionType.build:
            colony.addFreeVillagers(action.villagers);
            building = Building.create(
              buildingType: action.buildingType!,
              level: 1,
              villagers: 0,
            );
            actions.removeAt(0);
            break;
          case ActionType.levelUp:
            building!.level++;
            actions.removeAt(0);
            break;
          case ActionType.destroy:
            building = null;
            actions.removeAt(0);
            break;
          case ActionType.attack:
            // TODO(momo): implement
            break;
        }
      }
    } else if ((building != null) &&
        (building!.isProducer) &&
        (building!.hasVillagers)) {
      final Producer producer = building as Producer;
      colony.addResource(producer.produce());
    }
  }

  void build({
    required Colony colony,
    required BuildingType buildingType,
  }) {
    final ResourceMap cost = buildingType.cost(1);
    colony.removeResources(cost);
    colony.removeFreeVillagers(1);
    actions.add(Action.build(
      buildingType: buildingType,
      cost: cost,
    ));
  }

  void levelUp({
    required Colony colony,
    required Building building,
  }) {
    colony.removeResources(building.costNextLevel);
    actions.clear();
    actions.add(Action.levelUp(building.costNextLevel));
  }

  void destroy({
    required Colony colony,
    required Building building,
  }) {
    actions.clear();
    actions.add(Action.destroy());
  }

  void explore(Colony colony) {
    colony.removeResources(explorationCost);
    colony.removeFreeVillagers(1);
    actions.add(Action.explore());
  }

  void claim(Colony colony) {
    colony.removeResources(claimCost);
    colony.removeFreeVillagers(1);
    actions.add(Action.claim());
  }

  void trainVillager(Colony colony) {
    colony.removeResources(trainVillagerCost);
    actions.add(Action.train(1));
  }

  void cancel({
    required Colony colony,
    required Action action,
  }) {
    switch (action.actionType) {
      case ActionType.explore:
        colony.addResources(explorationCost);
        colony.addFreeVillagers(action.villagers);
        break;
      case ActionType.claim:
        colony.addResources(claimCost);
        colony.addFreeVillagers(action.villagers);
        break;
      case ActionType.train:
        colony.addResources(trainVillagerCost);
        break;
      case ActionType.build:
        colony.addResources(action.cost!);
        colony.addFreeVillagers(action.villagers);
        break;
      case ActionType.levelUp:
        colony.addResources(action.cost!);
        break;
      case ActionType.destroy:
        break;
      case ActionType.attack:
        // TODO(momo): implement
        break;
    }

    actions.remove(action);
  }
}
