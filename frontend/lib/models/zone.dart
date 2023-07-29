import 'package:flutter/material.dart' hide Action;
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/action.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/resource.dart';
import 'package:gatewayguardians/types/action_type.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/zone_status.dart';
import 'package:gatewayguardians/types/zone_type.dart';

class Zone {
  final int x;
  final int y;
  final ZoneType zoneType;
  final PatchType? patch;
  final List<Action> actions;
  String? owner;
  Building? building;
  ZoneStatus status;

  Zone({
    required this.x,
    required this.y,
    required this.zoneType,
    required this.patch,
    required this.actions,
    required this.owner,
    required this.building,
    required this.status,
  });

  String get id => '$x,$y';

  bool get isOwned => owner == Constants.PLAYER_OWNER;

  bool get isNeutral => owner == null;

  bool get hasAction => actions.isNotEmpty;

  Resource get explorationCost => Resource.food(10);

  Resource get claimCost => Resource.food(10);

  Resource get trainVillagerCost => Resource.food(10);

  Color get color {
    switch (zoneType) {
      case ZoneType.grass:
        return Colors.green;
      case ZoneType.desert:
        return Colors.orange;
      case ZoneType.snow:
        return Colors.white;
      case ZoneType.mountain:
        return Colors.brown;
      case ZoneType.water:
        return Colors.blue;
    }
  }

  List<BuildingType> basic() => [
        BuildingType.house,
        BuildingType.warehouse,
      ];

  List<BuildingType> producers() {
    final List<BuildingType> result = [];

    if (patch == PatchType.crop_field) {
      result.add(BuildingType.farm);
    }

    if (patch == PatchType.forest) {
      result.add(BuildingType.woodcutter);
    }

    if (patch == PatchType.stone_deposit) {
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
            colony.addFreeVillagers(action.villagers);
            status = ZoneStatus.explored;
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
            break;
          case ActionType.destroy:
            break;
          case ActionType.attack:
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
    colony.removeResources(buildingType.cost(1));
    colony.removeFreeVillagers(1);
    actions.add(Action.build(buildingType));
  }

  void explore(Colony colony) {
    colony.removeResource(explorationCost);
    colony.removeFreeVillagers(1);
    actions.add(Action.explore());
  }

  void claim(Colony colony) {
    colony.removeResource(claimCost);
    colony.removeFreeVillagers(1);
    actions.add(Action.claim());
  }

  void trainVillager(Colony colony) {
    colony.removeResource(trainVillagerCost);
    actions.add(Action.train(1));
  }

  void cancel({
    required Colony colony,
    required Action action,
  }) {
    switch (action.actionType) {
      case ActionType.explore:
        colony.addResource(explorationCost);
        colony.addFreeVillagers(action.villagers);
        break;
      case ActionType.claim:
        colony.addResource(claimCost);
        colony.addFreeVillagers(action.villagers);
        break;
      case ActionType.train:
        colony.addResource(trainVillagerCost);
        break;
      case ActionType.build:
        colony.addResources(action.buildingType!.cost(1));
        colony.addFreeVillagers(action.villagers);
        break;
      case ActionType.levelUp:
        break;
      case ActionType.destroy:
        break;
      case ActionType.attack:
        break;
    }

    actions.remove(action);
  }

  JsonZone get json => JsonZone(
        id: id,
        x: x.toDouble(),
        y: y.toDouble(),
        owner: owner ?? '',
        status: status,
        patches: [],
      );
}
