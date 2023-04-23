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
  "colony": {
    "inventory": {
      "food": 300,
      "wood": 100,
      "villager": 10
    },
    "freeVillagers": 10,
    "zones": [
      {
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
