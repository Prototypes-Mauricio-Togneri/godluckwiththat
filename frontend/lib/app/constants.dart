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
    "width": 1080,
    "height": 1920,
    "zones": [
      {
        "id": "1",
        "x": 84.033,
        "y": 1374.726
      },
      {
        "id": "2",
        "x": 301.318,
        "y": 930.226
      },
      {
        "id": "3",
        "x": 691.329,
        "y": 691.904
      },
      {
        "id": "4",
        "x": 180.193,
        "y": 286.014
      },
      {
        "id": "5",
        "x": 179.112,
        "y": 54.405
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
      }
    ]
  }
}
''';
}
