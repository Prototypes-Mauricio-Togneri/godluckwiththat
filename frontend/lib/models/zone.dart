import 'dart:ui';

import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/action.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/resource.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/types/action_type.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/tile_type.dart';
import 'package:gatewayguardians/types/zone_status.dart';

class Zone {
  final String id;
  final List<Tile> tiles;
  final List<Action> actions;
  String? owner;
  ZoneStatus status;

  Zone({
    required this.id,
    required this.tiles,
    required this.actions,
    required this.owner,
    required this.status,
  });

  bool get isOwn => owner == Constants.PLAYER_OWNER;

  bool get isNeutral => owner == null;

  bool get isHidden => status.isHidden;

  bool get isUnexplored => status.isUnexplored;

  bool get isExplored => status.isExplored;

  bool get hasPatch => tiles.any((t) => t.hasPatch);

  bool get hasAction => actions.isNotEmpty;

  bool get hasActionDestroy =>
      actions.isNotEmpty && (actions.first.actionType == ActionType.destroy);

  bool get hasActionLevelUp =>
      actions.isNotEmpty && (actions.first.actionType == ActionType.levelUp);

  ResourceMap get explorationCost => Resource.food(10).map;

  ResourceMap get claimCost => Resource.food(10).map;

  ResourceMap get trainVillagerCost => Resource.food(10).map;

  bool get isWater => tiles.every((t) => t.tileType == TileType.water);

  bool get canBeSelected =>
      !isHidden && tiles.any((tile) => tile.tileType.canSelected);

  Color get color {
    if (isOwn) {
      return Constants.PLAYER_COLOR;
    } else {
      return Constants.NEUTRAL_COLOR;
    }
  }

  bool isAnyNeighbor(Zone zone) {
    for (final Tile otherTile in zone.tiles) {
      for (final Tile ownTile in tiles) {
        if (ownTile.isAnyNeighbor(otherTile)) {
          return true;
        }
      }
    }

    return false;
  }

  bool isSideNeighbor(Zone zone) {
    for (final Tile otherTile in zone.tiles) {
      for (final Tile ownTile in tiles) {
        if (ownTile.isSideNeighbor(otherTile)) {
          return true;
        }
      }
    }

    return false;
  }

  bool isTopNeighbor(Tile tile) {
    for (final Tile ownTile in tiles) {
      if ((tile.id != ownTile.id) && tile.isTopNeighbor(ownTile)) {
        return true;
      }
    }

    return false;
  }

  bool isBottomNeighbor(Tile tile) {
    for (final Tile ownTile in tiles) {
      if ((tile.id != ownTile.id) && tile.isBottomNeighbor(ownTile)) {
        return true;
      }
    }

    return false;
  }

  bool isLeftNeighbor(Tile tile) {
    for (final Tile ownTile in tiles) {
      if ((tile.id != ownTile.id) && tile.isLeftNeighbor(ownTile)) {
        return true;
      }
    }

    return false;
  }

  bool isRightNeighbor(Tile tile) {
    for (final Tile ownTile in tiles) {
      if ((tile.id != ownTile.id) && tile.isRightNeighbor(ownTile)) {
        return true;
      }
    }

    return false;
  }

  bool canBeExplored(GameState state) {
    if (status.isUnexplored) {
      final List<Zone> neighbors = state.getSideNeighbors(this);

      for (final Zone zone in neighbors) {
        if (zone.isExplored) {
          return true;
        }
      }

      return false;
    } else {
      return false;
    }
  }

  bool canBeClaimed(GameState state) {
    if (status.isExplored) {
      final List<Zone> neighbors = state.getSideNeighbors(this);

      for (final Zone zone in neighbors) {
        if (zone.isOwn) {
          return true;
        }
      }

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

  void update(GameState state, Colony colony) {
    if (hasAction) {
      final Action action = actions.first;

      if (action.passTurn()) {
        switch (action.actionType) {
          case ActionType.explore:
            for (final Zone zone in state.getAllNeighbors(this)) {
              if (!zone.tiles.first.tileType.canExplored) {
                zone.status = ZoneStatus.explored;
              } else if (zone.isHidden) {
                zone.status = ZoneStatus.unexplored;
              }
            }
            status = ZoneStatus.explored;
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
            action.tile!.building = action.building!;
            actions.removeAt(0);
            break;
          case ActionType.levelUp:
            action.tile!.building!.level++;
            actions.removeAt(0);
            break;
          case ActionType.destroy:
            action.tile!.building = null;
            actions.removeAt(0);
            break;
          case ActionType.attack:
            // TODO(momo): implement
            break;
        }
      }
    } /* else if ((building != null) &&
        (building!.isProducer) &&
        (building!.hasVillagers)) {
      final Producer producer = building as Producer;
      colony.addResource(producer.produce());
    }*/
  }

  void queueExplore(Colony colony) {
    colony.removeResources(explorationCost);
    colony.removeFreeVillagers(1);
    actions.add(Action.explore());
  }

  void queueClaim(Colony colony) {
    colony.removeResources(claimCost);
    colony.removeFreeVillagers(1);
    actions.add(Action.claim());
  }

  void queueBuild({
    required Colony colony,
    required BuildingType buildingType,
  }) {
    final ResourceMap cost = buildingType.cost(1);
    colony.removeResources(cost);
    colony.removeFreeVillagers(1);
    /*actions.add(Action.build(
      buildingType: buildingType,
      cost: cost,
    ));*/
  }

  void queueLevelUp({
    required Colony colony,
    required Building building,
  }) {
    colony.removeResources(building.costNextLevel);
    actions.clear();
    //actions.add(Action.levelUp(building.costNextLevel));
  }

  void queueTrainVillager(Colony colony) {
    colony.removeResources(trainVillagerCost);
    actions.add(Action.train(1));
  }

  void queueDestroy({
    required Colony colony,
    required Building building,
  }) {
    actions.clear();
    //actions.add(Action.destroy());
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
