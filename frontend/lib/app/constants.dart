import 'package:flutter/material.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/zone_status.dart';
import 'package:gatewayguardians/types/zone_type.dart';

class Constants {
  static const String FONT_NAME = 'CustomFont';

  static const String PLAYER_OWNER = 'player';
  static const Color PLAYER_COLOR = Colors.blue;

  static const int HOUSE_POPULATION = 10;
  static const int HEADQUARTERS_POPULATION = 10;

  static const double FARM_PRODUCTION_TIME = 10;
  static const double WOODCUTTER_PRODUCTION_TIME = 10;
  static const double QUARRY_PRODUCTION_TIME = 10;
  static const double COPPER_MINE_PRODUCTION_TIME = 10;
  static const double IRON_MINE_PRODUCTION_TIME = 10;
  static const double GOLD_MINE_PRODUCTION_TIME = 10;

  static const String EMPTY_MATCH = '''
{
	"version": 1,
	"id": "level1",
	"totalTimeElapsed": 60,
	"level": 1,
  "map": {
    "path": "maps/chapter1",
    "width": 1300,
    "height": 1300
  },
  "zones": [
    {
      "id": "0,0",
      "x": 246.071,
      "y": 1050.502,
      "owner": "player",
      "status": "explored",
      "patches": [
        {
          "patch_type": "crop_field",
          "location": "west"
        },
        {
          "patch_type": "crop_field",
          "location": "east"
        },
        {
          "patch_type": "crop_field",
          "location": "south",
          "building": {
            "building_type": "headquarters",
            "level": 1,
            "workers": 0
          }
        }
      ]
    },
    {
      "id": "1,-1",
      "x": 515.647,
      "y": 889.996,
      "owner": "",
      "status": "unexplored",
      "patches": [
        {
          "patch_type": "crop_field",
          "location": "west"
        },
        {
          "patch_type": "forest",
          "location": "east"
        },
        {
          "patch_type": "crop_field",
          "location": "south"
        }
      ]
    },
    {
      "id": "1,-2",
      "x": 514.778,
      "y": 570.533,
      "owner": "",
      "status": "unexplored",
      "patches": []
    },
    {
      "id": "2,-2",
      "x": 785.224,
      "y": 729.49,
      "owner": "",
      "status": "unexplored",
      "patches": []
    },
    {
      "id": "2,-3",
      "x": 784.355,
      "y": 410.026,
      "owner": "",
      "status": "unexplored",
      "patches": []
    },
    {
      "id": "3,-4",
      "x": 1053.932,
      "y": 249.508,
      "owner": "guardians",
      "status": "unexplored",
      "patches": []
    }
  ],
  "colonies": [
    {
      "owner": "player",
      "color": "0000ff",
      "freeVillagers": 5,
      "inventory": {
        "food": 1000,
        "wood": 300,
        "villager": 5
      }
    },
    {
      "owner": "guardians",
      "color": "ff0000",
      "freeVillagers": 0,
      "inventory": {
        "food": 100,
        "wood": 100,
        "stone": 100,
        "villager": 10
      }
    }
  ]
}
''';

  static List<Zone> zones() {
    return [
      Zone(
        x: 0,
        y: 0,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        x: 1,
        y: 0,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        x: 2,
        y: 0,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        x: 3,
        y: 0,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        x: 0,
        y: 1,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        x: 1,
        y: 1,
        zoneType: ZoneType.grass,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        x: 2,
        y: 1,
        zoneType: ZoneType.grass,
        patches: [],
        actions: [],
        owner: Constants.PLAYER_OWNER,
        building: Building(
          buildingType: BuildingType.headquarters,
          level: 1,
          workers: 5,
        ),
        status: ZoneStatus.explored,
      ),
      Zone(
        x: 3,
        y: 1,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        x: 0,
        y: 2,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        x: 1,
        y: 2,
        zoneType: ZoneType.grass,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        x: 2,
        y: 2,
        zoneType: ZoneType.grass,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        x: 3,
        y: 2,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        x: 0,
        y: 3,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        x: 1,
        y: 3,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        x: 2,
        y: 3,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        x: 3,
        y: 3,
        zoneType: ZoneType.water,
        patches: [],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
    ];
  }
}
