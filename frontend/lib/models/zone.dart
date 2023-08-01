import 'dart:ui';

import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/action.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/buildings/producers/producer.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/resource.dart';
import 'package:gatewayguardians/types/action_type.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/zone_status.dart';
import 'package:gatewayguardians/types/zone_type.dart';
import 'package:gatewayguardians/utils/palette.dart';

class Zone {
  final int x;
  final int y;
  final ZoneType zoneType;
  final PatchType? patchType;
  final List<Action> actions;
  final Paint paintTest = Paint();
  String? owner;
  Building? building;
  ZoneStatus status;

  Zone({
    required this.x,
    required this.y,
    required this.zoneType,
    required this.patchType,
    required this.actions,
    required this.owner,
    required this.building,
    required this.status,
  }) {
    paintTest.color = Palette.white;
    paintTest.style = PaintingStyle.stroke;
  }

  String get id => '$x,$y';

  String get top => '$x,${y - 1}';

  String get topLeft => '${x - 1},${y - 1}';

  String get topRight => '${x + 1},${y - 1}';

  String get left => '${x - 1},$y';

  String get right => '${x + 1},$y';

  String get bottom => '$x,${y + 1}';

  String get bottomLeft => '${x - 1},${y + 1}';

  String get bottomRight => '${x + 1},${y + 1}';

  bool get isOwned => owner == Constants.PLAYER_OWNER;

  bool get isNeutral => owner == null;

  bool get isExplored => status == ZoneStatus.explored;

  bool get isUnexplored => status == ZoneStatus.unexplored;

  bool get hasPatch => patchType != null;

  bool get hasAction => actions.isNotEmpty;

  bool get hasActionDestroy =>
      actions.isNotEmpty && (actions.first.actionType == ActionType.destroy);

  bool get hasActionLevelUp =>
      actions.isNotEmpty && (actions.first.actionType == ActionType.levelUp);

  ResourceMap get explorationCost => Resource.food(10).map;

  ResourceMap get claimCost => Resource.food(10).map;

  ResourceMap get trainVillagerCost => Resource.food(10).map;

  bool isAnyNeighbor(Zone zone) =>
      (zone.id == top) ||
      (zone.id == topLeft) ||
      (zone.id == topRight) ||
      (zone.id == left) ||
      (zone.id == right) ||
      (zone.id == bottom) ||
      (zone.id == bottomLeft) ||
      (zone.id == bottomRight);

  bool isSideNeighbor(Zone zone) =>
      (zone.id == top) ||
      (zone.id == left) ||
      (zone.id == right) ||
      (zone.id == bottom);

  bool canBeExplored(Colony colony) {
    if (zoneType.canExplored && (status == ZoneStatus.explored)) {
      final List<Zone> neighbors = colony.getAllNeighbors(this);

      for (final Zone zone in neighbors) {
        if (zone.isUnexplored) {
          return true;
        }
      }

      return false;
    } else {
      return false;
    }
  }

  bool canBeClaimed(Colony colony) {
    if (zoneType.canBeClaimed && (status == ZoneStatus.explored)) {
      final List<Zone> neighbors = colony.getSideNeighbors(this);

      for (final Zone zone in neighbors) {
        if (zone.isOwned) {
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

    if (patchType == PatchType.crop_field) {
      result.add(BuildingType.farm);
    }

    if (patchType == PatchType.forest) {
      result.add(BuildingType.woodcutter);
    }

    if (patchType == PatchType.stone_deposit) {
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
            for (final Zone zone in colony.getAllNeighbors(this)) {
              zone.status = ZoneStatus.explored;
            }
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

  void draw({
    required Canvas canvas,
    required int canvasWidth,
    required double tileWidth,
    required double tileHeight,
    required double topGap,
  }) {
    paintTest.strokeWidth = canvasWidth / 700;

    final double i = (canvasWidth / 2) + ((x - y) * (tileWidth / 2));
    final double j = topGap + ((x + y) * (tileHeight / 2));

    final Path path = Path();
    path.moveTo(i, j - (tileHeight / 2));
    path.lineTo(i + (tileWidth / 2), j);
    path.lineTo(i, j + (tileHeight / 2));
    path.lineTo(i - (tileWidth / 2), j);
    path.close();
    canvas.drawPath(path, paintTest);
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
