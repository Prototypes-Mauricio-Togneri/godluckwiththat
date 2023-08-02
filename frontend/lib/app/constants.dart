import 'package:flutter/material.dart';
import 'package:gatewayguardians/models/buildings/misc/headquarters.dart';
import 'package:gatewayguardians/models/tile.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/tile_type.dart';
import 'package:gatewayguardians/types/zone_status.dart';

class Constants {
  static const String FONT_NAME = 'CustomFont';

  static const String PLAYER_OWNER = 'player';
  static final Color PLAYER_COLOR = Colors.blue[900]!;

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

  static List<Zone> zones() {
    return [
      Zone(
        id: '0,0',
        tiles: [
          Tile(
            x: 0,
            y: 0,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '1,0',
        tiles: [
          Tile(
            x: 1,
            y: 0,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '2,0',
        tiles: [
          Tile(
            x: 2,
            y: 0,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '3,0',
        tiles: [
          Tile(
            x: 3,
            y: 0,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '4,0',
        tiles: [
          Tile(
            x: 4,
            y: 0,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '5,0',
        tiles: [
          Tile(
            x: 5,
            y: 0,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '6,0',
        tiles: [
          Tile(
            x: 6,
            y: 0,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '0,1',
        tiles: [
          Tile(
            x: 0,
            y: 1,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '1,1',
        tiles: [
          Tile(
            x: 1,
            y: 1,
            tileType: TileType.grass,
            patchType: PatchType.forest,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '2,1',
        tiles: [
          Tile(
            x: 2,
            y: 1,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '3,1',
        tiles: [
          Tile(
            x: 3,
            y: 1,
            tileType: TileType.grass,
            patchType: PatchType.crop_field,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '4,1',
        tiles: [
          Tile(
            x: 4,
            y: 1,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '5,1',
        tiles: [
          Tile(
            x: 5,
            y: 1,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '6,1',
        tiles: [
          Tile(
            x: 6,
            y: 1,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '0,2',
        tiles: [
          Tile(
            x: 0,
            y: 2,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '1,2',
        tiles: [
          Tile(
            x: 1,
            y: 2,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '2,2',
        tiles: [
          Tile(
            x: 2,
            y: 2,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '3,2',
        tiles: [
          Tile(
            x: 3,
            y: 2,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '4,2',
        tiles: [
          Tile(
            x: 4,
            y: 2,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '5,2',
        tiles: [
          Tile(
            x: 5,
            y: 2,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '6,2',
        tiles: [
          Tile(
            x: 6,
            y: 2,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '0,3',
        tiles: [
          Tile(
            x: 0,
            y: 3,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '1,3',
        tiles: [
          Tile(
            x: 1,
            y: 3,
            tileType: TileType.grass,
            patchType: PatchType.forest,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '2,3',
        tiles: [
          Tile(
            x: 2,
            y: 3,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '3,3',
        tiles: [
          Tile(
            x: 3,
            y: 3,
            tileType: TileType.grass,
            patchType: PatchType.stone_deposit,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '4,3',
        tiles: [
          Tile(
            x: 4,
            y: 3,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '5,3',
        tiles: [
          Tile(
            x: 5,
            y: 3,
            tileType: TileType.grass,
            patchType: PatchType.forest,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '6,3',
        tiles: [
          Tile(
            x: 6,
            y: 3,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '0,4',
        tiles: [
          Tile(
            x: 0,
            y: 4,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        id: '1,4',
        tiles: [
          Tile(
            x: 1,
            y: 4,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        id: '2,4',
        tiles: [
          Tile(
            x: 2,
            y: 4,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        id: '3,4',
        tiles: [
          Tile(
            x: 3,
            y: 4,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '4,4',
        tiles: [
          Tile(
            x: 4,
            y: 4,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '5,4',
        tiles: [
          Tile(
            x: 5,
            y: 4,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '6,4',
        tiles: [
          Tile(
            x: 6,
            y: 4,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '0,5',
        tiles: [
          Tile(
            x: 0,
            y: 5,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        id: '1,5',
        tiles: [
          Tile(
            x: 1,
            y: 5,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: Constants.PLAYER_OWNER,
        building: Headquarters(
          level: 1,
          villagers: 5,
        ),
        status: ZoneStatus.explored,
      ),
      Zone(
        id: '2,5',
        tiles: [
          Tile(
            x: 2,
            y: 5,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.unexplored,
      ),
      Zone(
        id: '3,5',
        tiles: [
          Tile(
            x: 3,
            y: 5,
            tileType: TileType.grass,
            patchType: PatchType.crop_field,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '4,5',
        tiles: [
          Tile(
            x: 4,
            y: 5,
            tileType: TileType.grass,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '5,5',
        tiles: [
          Tile(
            x: 5,
            y: 5,
            tileType: TileType.grass,
            patchType: PatchType.forest,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '6,5',
        tiles: [
          Tile(
            x: 6,
            y: 5,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '0,6',
        tiles: [
          Tile(
            x: 0,
            y: 6,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        id: '1,6',
        tiles: [
          Tile(
            x: 1,
            y: 6,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        id: '2,6',
        tiles: [
          Tile(
            x: 2,
            y: 6,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.explored,
      ),
      Zone(
        id: '3,6',
        tiles: [
          Tile(
            x: 3,
            y: 6,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '4,6',
        tiles: [
          Tile(
            x: 4,
            y: 6,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '5,6',
        tiles: [
          Tile(
            x: 5,
            y: 6,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
      Zone(
        id: '6,6',
        tiles: [
          Tile(
            x: 6,
            y: 6,
            tileType: TileType.water,
            patchType: null,
          ),
        ],
        actions: [],
        owner: null,
        building: null,
        status: ZoneStatus.hidden,
      ),
    ];
  }
}
