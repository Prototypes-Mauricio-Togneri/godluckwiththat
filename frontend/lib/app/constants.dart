import 'package:flutter/material.dart';

class Constants {
  static const String FONT_NAME = 'CustomFont';

  static const double VIEWPORT_SIZE = 500;

  static const String PLAYER_OWNER = 'player';
  static const Color PLAYER_COLOR = Colors.blue;

  static const double RESOURCES_HUD_REFRESH_TIMEOUT = 1; // in seconds

  static const int HOUSE_POPULATION = 10;
  static const int HEADQUARTERS_POPULATION = 10;

  static const double FARM_PRODUCTION_TIME = 6;
  static const double WOODCUTTER_PRODUCTION_TIME = 6;
  static const double QUARRY_PRODUCTION_TIME = 6;
  static const double COPPER_MINE_PRODUCTION_TIME = 6;
  static const double IRON_MINE_PRODUCTION_TIME = 6;
  static const double GOLD_MINE_PRODUCTION_TIME = 6;

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
          "patch_type": "empty",
          "location": "east"
        },
        {
          "patch_type": "empty",
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
          "patch_type": "empty",
          "location": "west"
        },
        {
          "patch_type": "forest",
          "location": "east"
        },
        {
          "patch_type": "empty",
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
        "food": 300,
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
}
