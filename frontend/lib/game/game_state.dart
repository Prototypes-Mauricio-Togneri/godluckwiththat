import 'package:dafluta/dafluta.dart';
import 'package:flame/components.dart';
import 'package:gatewayguardians/app/constants.dart';
import 'package:gatewayguardians/components/zone_component.dart';
import 'package:gatewayguardians/dialog/build_dialog.dart';
import 'package:gatewayguardians/extensions/resource_map_extension.dart';
import 'package:gatewayguardians/game/game_component.dart';
import 'package:gatewayguardians/json/json_colony.dart';
import 'package:gatewayguardians/json/json_match.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/colony.dart';
import 'package:gatewayguardians/models/construction.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/models/research.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/utils/loaders.dart';

class GameState extends BaseState {
  num totalTimeElapsed = 0;
  num refreshTimeout = 0;
  bool loaded = false;
  bool clickHandled = false;

  final Research research = Research();
  final JsonMatch jsonMatch;
  final List<Zone> zones = [];
  final List<Colony> colonies = [];
  late Colony colony;

  Zone? selectedZone;
  Patch? selectedPatch;
  Building? selectedBuilding;

  static late GameState instance;

  GameState(this.jsonMatch);

  void load() {
    totalTimeElapsed = jsonMatch.totalTimeElapsed;

    for (final JsonColony jsonColony in jsonMatch.colonies) {
      colonies.add(Loaders.colony(jsonColony));
    }

    for (final JsonZone jsonZone in jsonMatch.zones) {
      zones.add(Loaders.zone(jsonZone));
    }

    colony = _colonyByOwner(Constants.PLAYER_OWNER);

    for (final Zone zone in zones) {
      if (zone.owner.isNotEmpty) {
        final Colony colony = _colonyByOwner(zone.owner);
        colony.zones.add(zone);
      }
    }

    Delayed.post(() {
      loaded = true;
      notify();
    });
  }

  void update(double dt) {
    totalTimeElapsed += dt;
    refreshTimeout += dt;

    if (refreshTimeout > Constants.RESOURCES_HUD_REFRESH_TIMEOUT) {
      refreshTimeout--;
      notify();
    }

    for (final Zone zone in zones) {
      zone.update(dt);
    }
  }

  Colony _colonyByOwner(String owner) {
    for (final Colony colony in colonies) {
      if (colony.owner == owner) {
        return colony;
      }
    }

    throw Exception('Colony not found for owner $owner');
  }

  void onMapClicked(Vector2 position) {
    if (!clickHandled) {
      final Iterable<Component> allComponents =
          GameComponent.instance.layerSprites.descendants();

      final List<ZoneComponent> zoneList =
          allComponents.whereType<ZoneComponent>().toList();

      selectedZone = null;
      selectedPatch = null;
      selectedBuilding = null;

      for (final ZoneComponent zone in zoneList) {
        if (zone.containsPosition(position)) {
          onZoneSelected(zone.zone);
          break;
        }
      }

      notify();
    }

    clickHandled = false;
  }

  void onMouseMoved(Vector2 position) {
    final Iterable<Component> allComponents =
        GameComponent.instance.layerSprites.descendants();

    final List<ZoneComponent> zoneList =
        allComponents.whereType<ZoneComponent>().toList();

    for (final ZoneComponent zone in zoneList) {
      if (zone.containsPosition(position)) {
        zone.onHoverEnter();
      } else {
        zone.onHoverLeave();
      }
    }

    final List<ZoneBuildingComponent> buildingList =
        allComponents.whereType<ZoneBuildingComponent>().toList();

    for (final ZoneBuildingComponent building in buildingList) {
      if (building.containsPosition(position)) {
        building.onHoverEnter();
      } else {
        building.onHoverLeave();
      }
    }

    final List<ZonePatchComponent> patchList =
        allComponents.whereType<ZonePatchComponent>().toList();

    for (final ZonePatchComponent patch in patchList) {
      if (patch.containsPosition(position)) {
        patch.onHoverEnter();
      } else {
        patch.onHoverLeave();
      }
    }
  }

  void onZoneSelected(Zone zone) {
    selectedZone = zone;
    selectedPatch = null;
    selectedBuilding = null;
    clickHandled = true;
    notify();
  }

  void onPatchSelected(Patch patch) {
    selectedZone = null;
    selectedPatch = patch;
    selectedBuilding = null;
    clickHandled = true;
    notify();
  }

  void onBuildingSelected(Building building) {
    selectedZone = null;
    selectedPatch = null;
    selectedBuilding = building;
    clickHandled = true;
    notify();
  }

  void onBuildOnPatch(Patch patch) {
    selectedPatch = null;
    notify();

    BuildDialog.show(
      state: this,
      patch: patch,
    );
  }

  void onExploreZone(Zone zone) {
    colony.inventory.removeResources(zone.cost().resources());
    zone.explore();
    selectedZone = null;

    GameComponent.instance.loadMap(this);
    notify();
  }

  void onStartConstruction(Construction construction) {
    construction.zone.constructions.add(construction);
  }

  void onConstructionCompleted(Construction construction) {
    final Zone zone = construction.zone;
    zone.constructions.remove(construction);

    final BuildingType buildingType = construction.buildingType;
    final ResourceMap cost = buildingType.cost(construction.toLevel);
    colony.inventory.removeResources(cost.resources());

    construction.patch.building = Building.create(
      buildingType: buildingType,
      level: 1,
      workers: 0,
    );

    GameComponent.instance.loadMap(this);
    notify();
  }

  void onDestroyBuilding(Building building) {
    for (final Zone zone in zones) {
      zone.onDestroyBuilding(building);
    }

    selectedBuilding = null;
    GameComponent.instance.loadMap(this);
    notify();
  }

  void onOpenMainMenu() {}

  void onOpenReportsMenu() {}

  void onOpenExpeditionsMenu() {}

  JsonMatch get json => JsonMatch(
        version: jsonMatch.version,
        id: jsonMatch.id,
        totalTimeElapsed: totalTimeElapsed,
        level: jsonMatch.level,
        map: jsonMatch.map,
        zones: zones.map((z) => z.json).toList(),
        colonies: colonies.map((c) => c.json).toList(),
      );
}
