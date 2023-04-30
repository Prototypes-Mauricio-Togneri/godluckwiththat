class Constants {
  static const String FONT_NAME = 'CustomFont';

  static const double VIEWPORT_SIZE = 500;

  static const String ZONE_OWNER_PLAYER = 'player';

  static const double RESOURCES_HUD_REFRESH_TIMEOUT = 1; // in seconds

  static const int HOUSE_POPULATION = 10;
  static const int HEADQUARTERS_POPULATION = 10;

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
      "id": "1",
      "x": 246.071,
      "y": 1050.502,
      "owner": "player",
      "maxBuildings": 4,
      "status": "explored",
      "patches": [
        {
          "type": "crop_field",
          "location": "west"
        },
        {
          "type": "forest",
          "location": "east"
        }
      ],
      "buildings": [
        {
          "type": "headquarters",
          "level": 2,
          "workers": 0
        },
        {
          "type": "farm",
          "level": 1,
          "workers": 0,
          "location": "west"
        }
      ]
    },
    {
      "id": "2",
      "x": 515.647,
      "y": 889.996,
      "owner": "",
      "maxBuildings": 4,
      "status": "explored",
      "patches": [],
      "buildings": []
    },
    {
      "id": "3",
      "x": 785.224,
      "y": 729.49,
      "owner": "",
      "maxBuildings": 4,
      "status": "unexplored",
      "patches": [],
      "buildings": []
    },
    {
      "id": "4",
      "x": 514.778,
      "y": 570.533,
      "owner": "",
      "maxBuildings": 4,
      "status": "unexplored",
      "patches": [],
      "buildings": []
    },
    {
      "id": "5",
      "x": 784.355,
      "y": 410.026,
      "owner": "",
      "maxBuildings": 4,
      "status": "unexplored",
      "patches": [],
      "buildings": []
    },
    {
      "id": "6",
      "x": 1053.932,
      "y": 249.508,
      "owner": "guardians",
      "maxBuildings": 4,
      "status": "unexplored",
      "patches": [],
      "buildings": []
    }
  ],
  "colony": {
    "inventory": {
      "food": 300,
      "wood": 200,
      "stone": 100,
      "villager": 10
    },
    "freeVillagers": 10
  }
}
''';
}
