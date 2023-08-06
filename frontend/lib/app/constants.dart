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
    Tile(
      x: 1,
      y: 0,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 2,
      y: 0,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 3,
      y: 0,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 5,
      y: 0,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 0,
      y: 1,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 3,
      y: 1,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 4,
      y: 1,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 5,
      y: 1,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 6,
      y: 1,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 0,
      y: 2,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 2,
      y: 2,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 3,
      y: 2,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 4,
      y: 2,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 0,
      y: 3,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 1,
      y: 3,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 2,
      y: 3,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 4,
      y: 3,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 5,
      y: 3,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 6,
      y: 3,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 2,
      y: 4,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 3,
      y: 4,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 4,
      y: 4,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 6,
      y: 4,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 0,
      y: 5,
      type: TileType.water,
      status: TileStatus.revealed,
    ),
    Tile(
      x: 1,
      y: 5,
      type: TileType.water,
      status: TileStatus.revealed,
    ),
    Tile(
      x: 2,
      y: 5,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 3,
      y: 5,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 6,
      y: 5,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 1,
      y: 6,
      type: TileType.water,
      status: TileStatus.revealed,
    ),
    Tile(
      x: 3,
      y: 6,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 4,
      y: 6,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 5,
      y: 6,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 6,
      y: 6,
      type: TileType.water,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 0,
      y: 6,
      type: TileType.grass,
      status: TileStatus.revealed,
    ),
    Tile(
      x: 2,
      y: 6,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 5,
      y: 4,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 4,
      y: 5,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 5,
      y: 5,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 0,
      y: 4,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 1,
      y: 4,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 3,
      y: 3,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 1,
      y: 1,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 2,
      y: 1,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 1,
      y: 2,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 5,
      y: 2,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 6,
      y: 2,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 4,
      y: 0,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
    Tile(
      x: 6,
      y: 0,
      type: TileType.grass,
      status: TileStatus.hidden,
    ),
  ];

  static List<Island> islands = [
    Island(
      id: '0',
      tiles: getTiles([
        [0, 0],
        [1, 0],
        [2, 0],
        [3, 0],
        [5, 0],
        [0, 1],
        [3, 1],
        [4, 1],
        [5, 1],
        [6, 1],
        [0, 2],
        [2, 2],
        [3, 2],
        [4, 2],
        [0, 3],
        [1, 3],
        [2, 3],
        [4, 3],
        [5, 3],
        [6, 3],
        [2, 4],
        [3, 4],
        [4, 4],
        [6, 4],
        [0, 5],
        [1, 5],
        [2, 5],
        [3, 5],
        [6, 5],
        [1, 6],
        [3, 6],
        [4, 6],
        [5, 6],
        [6, 6]
      ]),
      actions: [],
      patches: [],
      buildings: [],
      owner: null,
    ),
    Island(
      id: '1',
      tiles: getTiles([
        [0, 6]
      ]),
      actions: [],
      patches: [],
      buildings: [],
      owner: null,
    ),
    Island(
      id: '2',
      tiles: getTiles([
        [2, 6]
      ]),
      actions: [],
      patches: [PatchType.crop_field],
      buildings: [],
      owner: null,
    ),
    Island(
      id: '3',
      tiles: getTiles([
        [5, 4],
        [4, 5],
        [5, 5]
      ]),
      actions: [],
      patches: [PatchType.crop_field, PatchType.forest],
      buildings: [],
      owner: null,
    ),
    Island(
      id: '4',
      tiles: getTiles([
        [0, 4],
        [1, 4]
      ]),
      actions: [],
      patches: [PatchType.forest],
      buildings: [],
      owner: null,
    ),
    Island(
      id: '5',
      tiles: getTiles([
        [3, 3]
      ]),
      actions: [],
      patches: [PatchType.stone_deposit],
      buildings: [],
      owner: null,
    ),
    Island(
      id: '6',
      tiles: getTiles([
        [1, 1],
        [2, 1],
        [1, 2]
      ]),
      actions: [],
      patches: [PatchType.forest, PatchType.crop_field],
      buildings: [],
      owner: null,
    ),
    Island(
      id: '7',
      tiles: getTiles([
        [5, 2],
        [6, 2]
      ]),
      actions: [],
      patches: [PatchType.forest],
      buildings: [],
      owner: null,
    ),
    Island(
      id: '8',
      tiles: getTiles([
        [4, 0]
      ]),
      actions: [],
      patches: [PatchType.crop_field],
      buildings: [],
      owner: null,
    ),
    Island(
      id: '9',
      tiles: getTiles([
        [6, 0]
      ]),
      actions: [],
      patches: [],
      buildings: [],
      owner: null,
    ),
  ];
}
