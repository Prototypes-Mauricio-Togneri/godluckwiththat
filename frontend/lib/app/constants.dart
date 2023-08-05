import 'package:flutter/material.dart';
import 'package:gatewayguardians/models/island.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/tile_type.dart';
import 'package:gatewayguardians/types/type_status.dart';

class Constants {
  static const String FONT_NAME = 'CustomFont';

  static const String PLAYER_OWNER = 'player';
  static final Color PLAYER_COLOR = Colors.blue[900]!;

  static final Color NEUTRAL_COLOR = Colors.grey[700]!;

  static const int HOUSE_POPULATION = 10;
  static const int HEADQUARTERS_POPULATION = 10;

  static const int FARM_PRODUCTION_RATE = 10;
  static const int WOODCUTTER_PRODUCTION_RATE = 10;
  static const int QUARRY_PRODUCTION_RATE = 10;
  static const int COPPER_MINE_PRODUCTION_RATE = 10;
  static const int IRON_MINE_PRODUCTION_RATE = 10;
  static const int GOLD_MINE_PRODUCTION_RATE = 10;

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

  static List<Tile> getTiles(List<List<int>> ids) {
    final List<Tile> result = [];

    for (final Tile tile in tiles) {
      for (final List<int> id in ids) {
        if ((tile.x == id[0]) && (tile.y == id[1])) {
          result.add(tile);
        }
      }
    }

    return result;
  }

  static List<Tile> tiles = [
    Tile(
      x: 0,
      y: 0,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
  ];

  static List<Island> islands = [
    Island(
      id: '1',
      tiles: getTiles([
        [0, 0],
        [0, 1],
      ]),
      actions: [],
      patches: [PatchType.crop_field],
      buildings: [],
      owner: null,
    ),
  ];
}
