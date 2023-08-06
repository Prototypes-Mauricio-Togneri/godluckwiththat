import 'dart:ui';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/action.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/player.dart';
import 'package:gatewayguardians/models/resource.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/types/action_type.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/patch_type.dart';

class Island {
  final String id;
  final List<Tile> tiles;
  final List<Action> actions;
  final List<PatchType> patches;
  final List<Building> buildings;
  Player? owner;

  Island({
    required this.id,
    required this.tiles,
    required this.actions,
    required this.patches,
    required this.buildings,
    required this.owner,
  });

  bool get isOwn => (owner != null) && owner!.isOwn;

  bool get isNeutral => owner == null;

  bool get hasAction => actions.isNotEmpty;

  bool get hasPatches => patches.isNotEmpty;

  bool hasPatch(PatchType type) => patches.any((p) => p == type);

  bool get hasActionDestroy =>
      actions.isNotEmpty && (actions.first.actionType == ActionType.destroy);

  bool get hasActionLevelUp =>
      actions.isNotEmpty && (actions.first.actionType == ActionType.levelUp);

  ResourceMap get explorationCost => Resource.food(10).map;

  ResourceMap get claimCost => Resource.food(10).map;

  ResourceMap get trainVillagerCost => Resource.food(10).map;

  bool get canBeSelected => tiles.every((tile) => tile.isRevealed);

  Color get color => owner!.color;

  List<BuildingType> basic() => [
        BuildingType.house,
        BuildingType.warehouse,
      ];

  List<BuildingType> producers() {
    final List<BuildingType> result = [];

    if (hasPatch(PatchType.crop_field)) {
      result.add(BuildingType.farm);
    }

    if (hasPatch(PatchType.forest)) {
      result.add(BuildingType.woodcutter);
    }

    if (hasPatch(PatchType.stone_deposit)) {
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
            /*for (final Zone zone in state.getAllNeighbors(this)) {
              if (!zone.tiles.first.tileType.canExplored) {
                zone.status = ZoneStatus.explored;
              } else if (zone.isHidden) {
                zone.status = ZoneStatus.unexplored;
              }
            }
            status = ZoneStatus.explored;
            colony.addFreeVillagers(action.villagers);
            actions.removeAt(0);*/
            break;
          case ActionType.claim:
            //colony.addFreeVillagers(action.villagers);
            //owner = Constants.PLAYER_OWNER;
            //actions.removeAt(0);
            break;
          case ActionType.train:
            //colony.addFreeVillagers(1);
            //colony.addResource(Resource.villager(1));
            //actions.removeAt(0);
            break;
          case ActionType.build:
            //colony.addFreeVillagers(action.villagers);
            //action.tile!.building = action.building!;
            //actions.removeAt(0);
            break;
          case ActionType.levelUp:
            //action.tile!.building!.level++;
            //actions.removeAt(0);
            break;
          case ActionType.destroy:
            //action.tile!.building = null;
            //actions.removeAt(0);
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
