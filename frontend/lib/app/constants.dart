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
    "height": 1320
  },
  "zones": [
    {
      "id": "1",
      "x": 24.944,
      "y": 976.082,
      "maxBuildings": 4,
      "status": "explored",
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
      "x": 297.811,
      "y": 817.540,
      "maxBuildings": 4,
      "status": "explored",
      "patches": [],
      "buildings": []
    },
    {
      "id": "3",
      "x": 570.677,
      "y": 658.998,
      "maxBuildings": 4,
      "status": "explored",
      "patches": [],
      "buildings": []
    },
    {
      "id": "4",
      "x": 296.942,
      "y": 501.967,
      "maxBuildings": 4,
      "status": "explored",
      "patches": [],
      "buildings": []
    },
    {
      "id": "5",
      "x": 569.808,
      "y": 343.387,
      "maxBuildings": 4,
      "status": "explored",
      "patches": [],
      "buildings": []
    },
    {
      "id": "6",
      "x": 568.901,
      "y": 27.815,
      "maxBuildings": 4,
      "status": "explored",
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
