class Constants {
  static const String FONT_NAME = 'CustomFont';

  static double VIEWPORT_SIZE = 500;

  static double RESOURCES_HUD_REFRESH_TIMEOUT = 1; // in seconds

  static int HOUSE_POPULATION = 10;
  static int HEADQUARTERS_POPULATION = 10;

  static String EMPTY_MATCH = '''
{
	"version": 1,
	"id": "level1",
	"totalTimeElapsed": 60,
	"level": 1,
  "map": {
    "path": "maps/chapter1",
    "width": 960,
    "height": 1320,
    "zones": [
      {
        "id": "1",
        "x": 22.445,
        "y": 973.582
      },
      {
        "id": "2",
        "x": 295.311,
        "y": 815.078
      },
      {
        "id": "3",
        "x": 568.177,
        "y": 656.498
      },
      {
        "id": "4",
        "x": 294.442,
        "y": 499.467
      },
      {
        "id": "5",
        "x": 567.308,
        "y": 340.887
      },
      {
        "id": "6",
        "x": 566.439,
        "y": 25.319
      }
    ]
  },
  "colony": {
    "inventory": {
      "food": 300,
      "wood": 200,
      "stone": 100,
      "villager": 10
    },
    "freeVillagers": 10,
    "zones": [
      {
        "id": "1",
        "maxBuildings": 4,
        "patches": [
          {
            "type": "food",
            "location": "north"
          },
          {
            "type": "wood",
            "location": "south"
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
            "location": "north"
          }
        ]
      },
      {
        "id": "2",
        "maxBuildings": 4,
        "patches": [],
        "buildings": []
      },
      {
        "id": "3",
        "maxBuildings": 4,
        "patches": [],
        "buildings": []
      },
      {
        "id": "4",
        "maxBuildings": 4,
        "patches": [],
        "buildings": []
      },
      {
        "id": "5",
        "maxBuildings": 4,
        "patches": [],
        "buildings": []
      },
      {
        "id": "6",
        "maxBuildings": 4,
        "patches": [],
        "buildings": []
      }
    ]
  }
}
''';
}
