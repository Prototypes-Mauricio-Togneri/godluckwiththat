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
import 'package:gatewayguardians/models/player.dart';
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
  final List<Tile> tiles = [];
  final List<Island> islands = [];
  late final Colony colony;

  MapPainter? mapPainter;
  Island? selectedIsland;

  GameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    tiles.addAll(Constants.tiles);
    islands.addAll(Constants.islands);

    mapWidth = sqrt(islands.length).toInt();
    mapHeight = sqrt(islands.length).toInt();

    colony = Colony(
      owner: Player.you(),
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

    for (final Island island in islands) {
      tiles += island.tiles.length;
    }

    return sqrt(tiles).toInt();
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
    for (final Island island in islands) {
      if (island.isRevealed &&
          mapPainter!.isInsideIsland(
            island: island,
            offset: details.localPosition,
          )) {
        if (selectedIsland != island) {
          selectedIsland = island;
        } else {
          selectedIsland = null;
        }
        notify();
        break;
      }
    }
  }

  void onBuild(Island island) => BuildDialog.show(
        state: this,
        island: island,
      );

  void build({
    required Island island,
    required BuildingType buildingType,
  }) {
    island.queueBuild(
      colony: colony,
      buildingType: buildingType,
    );
    notify();
  }

  void levelUp({
    required Island island,
    required Building building,
  }) {
    island.queueLevelUp(
      colony: colony,
      building: building,
    );
    notify();
  }

  void destroy({
    required Island island,
    required Building building,
  }) {
    island.queueDestroy(
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

  void explore(Island island) {
    island.queueExplore(colony);
    notify();
  }

  void claim(Island island) {
    island.queueClaim(colony);
    notify();
  }

  void trainVillager(Island island) {
    island.queueTrainVillager(colony);
    notify();
  }

  void cancel({
    required Island island,
    required Action action,
  }) {
    island.cancel(
      colony: colony,
      action: action,
    );
    notify();
  }

  void onPassTurn() {
    turn++;

    for (final Island island in islands) {
      island.update(this, colony);
    }

    selectedIsland = null;
    notify();
  }

  void onOpenMainMenu() {}
}
