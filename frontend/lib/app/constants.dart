class Constants {
  static const String FONT_NAME = 'CustomFont';

  static double VIEWPORT_SIZE = 500;

  static double RESOURCES_HUD_REFRESH_TIMEOUT = 1; // in seconds

  static String EMPTY_MATCH = '''
{
	"version": 1,
	"id": "level1",
	"totalTimeElapsed": 60,
	"level": 1,
	"villages": [
    {
      "name": "Momo's village",
      "inventory": {
        "food": 300,
        "wood": 100,
        "villager": 10
      },
      "freeVillagers": 10,
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
          "villagers": 0
        },
        {
          "type": "farm",
          "level": 1,
          "villagers": 0,
          "location": "north"
        }
      ]
    }
  ]
}
''';
}
