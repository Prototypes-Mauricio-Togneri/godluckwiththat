import 'package:flutter/material.dart' hide Action;
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/action.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/resource.dart';
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

  void update(Colony colony) {
    if (hasAction) {
      final Action action = actions[0];

      if (action.passTurn()) {
        if (action.isExplore) {
          colony.addFreeVillagers(action.villagers);
          status = ZoneStatus.explored;
          actions.removeAt(0);
        } else if (action.isClaim) {
          colony.addFreeVillagers(action.villagers);
          owner = Constants.PLAYER_OWNER;
          actions.removeAt(0);
        } else if (action.isClaim) {
          colony.addFreeVillagers(1);
          colony.addResource(Resource.villager(1));
          actions.removeAt(0);
        }
      }
    }
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
    if (action.isExplore) {
      colony.addResource(explorationCost);
      colony.addFreeVillagers(action.villagers);
    } else if (action.isClaim) {
      colony.addResource(claimCost);
      colony.addFreeVillagers(action.villagers);
    } else if (action.isTrain) {
      colony.addResource(trainVillagerCost);
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
