import 'dart:math';
import 'package:dafluta/dafluta.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/dialog/build_dialog.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/models/action.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/inventory.dart';
import 'package:gatewayguardians/models/island.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';
import 'package:gatewayguardians/ui/map_painter.dart';

class GameState extends BaseState {
  int turn = 1;
  num totalTimeElapsed = 0;
  final FocusNode focusNode = FocusNode();

  late final int mapWidth;
  late final int mapHeight;

  final JsonMatch jsonMatch;
  final List<Island> islands = [];
  late final Colony colony;

  MapPainter? mapPainter;
  Island? selectedIsland;

  GameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    islands.addAll(Constants.islands());

    mapWidth = sqrt(islands.length).toInt();
    mapHeight = sqrt(islands.length).toInt();

    colony = Colony(
      owner: Constants.PLAYER_OWNER,
      color: Constants.PLAYER_COLOR,
      inventory: Inventory.fromResourceMap({
        ResourceType.villager: 5,
        ResourceType.food: 200,
        ResourceType.wood: 200,
      }),
      freeVillagers: 5,
    );
  }

  int mapSize() {
    int tiles = 0;

    for (final Zone zone in islands) {
      tiles += zone.tiles.length;
    }

    return sqrt(tiles).toInt();
  }

  List<Zone> getAllNeighbors(Zone center) {
    final List<Zone> result = [];

    for (final Zone zone in islands) {
      if ((zone.id != center.id) && center.isAnyNeighbor(zone)) {
        result.add(zone);
      }
    }

    return result;
  }

  List<Zone> getSideNeighbors(Zone center) {
    final List<Zone> result = [];

    for (final Zone zone in islands) {
      if ((zone.id != center.id) && center.isSideNeighbor(zone)) {
        result.add(zone);
      }
    }

    return result;
  }

  Zone? topNeighbor(Tile tile) {
    for (final Zone zone in islands) {
      if (zone.isTopNeighbor(tile)) {
        return zone;
      }
    }

    return null;
  }

  Zone? bottomNeighbor(Tile tile) {
    for (final Zone zone in islands) {
      if (zone.isBottomNeighbor(tile)) {
        return zone;
      }
    }

    return null;
  }

  Zone? leftNeighbor(Tile tile) {
    for (final Zone zone in islands) {
      if (zone.isLeftNeighbor(tile)) {
        return zone;
      }
    }

    return null;
  }

  Zone? rightNeighbor(Tile tile) {
    for (final Zone zone in islands) {
      if (zone.isRightNeighbor(tile)) {
        return zone;
      }
    }

    return null;
  }

  void setMapPainter(MapPainter painter) {
    mapPainter = painter;
  }

  void onKey(RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.space) && !event.repeat) {
      onPassTurn();
    }
  }

  void onTapDown(TapDownDetails details) {
    for (final Zone zone in islands) {
      if (zone.canBeSelected &&
          mapPainter!.isInsideZone(
            zone: zone,
            offset: details.localPosition,
          )) {
        if (selectedIsland != zone) {
          selectedIsland = zone;
        } else {
          selectedIsland = null;
        }
        notify();
        break;
      }
    }
  }

  void onBuild(Zone zone) => BuildDialog.show(
        state: this,
        zone: zone,
      );

  void build({
    required Zone zone,
    required BuildingType buildingType,
  }) {
    zone.queueBuild(
      colony: colony,
      buildingType: buildingType,
    );
    notify();
  }

  void levelUp({
    required Zone zone,
    required Building building,
  }) {
    zone.queueLevelUp(
      colony: colony,
      building: building,
    );
    notify();
  }

  void destroy({
    required Zone zone,
    required Building building,
  }) {
    zone.queueDestroy(
      colony: colony,
      building: building,
    );
    notify();
  }

  void addVillager(Building building) {
    if (colony.hasFreeVillagers) {
      building.addVillagers(colony.removeFreeVillagers(1));
      notify();
    }
  }

  void removeVillager(Building building) {
    if (building.hasVillagers) {
      building.removeVillagers(colony.addFreeVillagers(1));
      notify();
    }
  }

  void explore(Zone zone) {
    zone.queueExplore(colony);
    notify();
  }

  void claim(Zone zone) {
    zone.queueClaim(colony);
    notify();
  }

  void trainVillager(Zone zone) {
    zone.queueTrainVillager(colony);
    notify();
  }

  void cancel({
    required Zone zone,
    required Action action,
  }) {
    zone.cancel(
      colony: colony,
      action: action,
    );
    notify();
  }

  void onPassTurn() {
    turn++;

    for (final Zone zone in islands) {
      zone.update(this, colony);
    }

    selectedIsland = null;
    notify();
  }

  void onOpenMainMenu() {}
}
