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
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class GameState extends BaseState {
  int turn = 1;
  num totalTimeElapsed = 0;
  final FocusNode focusNode = FocusNode();

  late final int mapWidth;
  late final int mapHeight;

  final JsonMatch jsonMatch;
  final List<Zone> zones = [];
  late final Colony colony;

  Zone? selectedZone;

  GameState(this.jsonMatch) {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    zones.addAll(Constants.zones());

    mapWidth = sqrt(zones.length).toInt();
    mapHeight = sqrt(zones.length).toInt();

    colony = Colony(
      owner: Constants.PLAYER_OWNER,
      color: Constants.PLAYER_COLOR,
      inventory: Inventory.fromResourceMap({
        ResourceType.villager: 5,
        ResourceType.food: 50,
        ResourceType.wood: 200,
      }),
      zones: zones,
      freeVillagers: 5,
    );
  }

  void onKey(RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.space) && !event.repeat) {
      onPassTurn();
    }
  }

  void onTapDown(TapDownDetails details) {
    for (final Zone zone in zones) {
      if (zone.renderer.isInside(details.localPosition)) {
        if (selectedZone != zone) {
          selectedZone = zone;
        } else {
          selectedZone = null;
        }
      }
    }
  }

  void onZoneClicked(Zone zone) {
    if (selectedZone != zone) {
      selectedZone = zone;
    } else {
      selectedZone = null;
    }

    notify();
  }

  void onBuild(Zone zone) => BuildDialog.show(
        state: this,
        zone: zone,
      );

  void build({
    required Zone zone,
    required BuildingType buildingType,
  }) {
    zone.build(
      colony: colony,
      buildingType: buildingType,
    );
    notify();
  }

  void levelUp({
    required Zone zone,
    required Building building,
  }) {
    zone.levelUp(
      colony: colony,
      building: building,
    );
    notify();
  }

  void destroy({
    required Zone zone,
    required Building building,
  }) {
    zone.destroy(
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
    zone.explore(colony);
    notify();
  }

  void claim(Zone zone) {
    zone.claim(colony);
    notify();
  }

  void trainVillager(Zone zone) {
    zone.trainVillager(colony);
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

    for (final Zone zone in zones) {
      zone.update(colony);
    }

    selectedZone = null;
    notify();
  }

  void onOpenMainMenu() {}

  JsonMatch get json => JsonMatch(
        version: jsonMatch.version,
        id: jsonMatch.id,
        totalTimeElapsed: totalTimeElapsed,
        level: jsonMatch.level,
        map: jsonMatch.map,
        zones: zones.map((z) => z.json).toList(),
        colonies: [],
      );
}
