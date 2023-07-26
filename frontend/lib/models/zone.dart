import 'package:flutter/material.dart' hide Action;
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/actions/action.dart';
import 'package:gatewayguardians/models/actions/action_explore.dart';
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
  final List<PatchType> patches;
  final List<Action> actions;
  String? owner;
  Building? building;
  ZoneStatus status;

  Zone({
    required this.x,
    required this.y,
    required this.zoneType,
    required this.patches,
    required this.actions,
    required this.owner,
    required this.building,
    required this.status,
  });

  String get id => '$x,$y';

  bool get isOwned => owner == Constants.PLAYER_OWNER;

  bool get isNeutral => owner == null;

  bool get hasAction => actions.isNotEmpty;

  bool get hasActionExplore => actions.isNotEmpty && actions[0].isExplore;

  Resource get explorationCost => Resource.food(10);

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
    if (hasActionExplore) {
      colony.addFreeVillager();
      status = ZoneStatus.explored;
    }
  }

  void explore(Colony colony) {
    colony.removeResource(explorationCost);
    colony.removeFreeVillager();
    actions.add(ActionExplore());
  }

  void cancel(Colony colony) {
    if (hasActionExplore) {
      colony.addResource(explorationCost);
      colony.addFreeVillager();
    }

    actions.clear();
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
