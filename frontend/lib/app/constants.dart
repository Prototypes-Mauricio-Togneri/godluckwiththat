class Constants {
  static const String FONT_NAME = 'CustomFont';

  static const int SECONDS_PER_DAY = 6;

  static const int HOUSE_POPULATION = 5;
  static const int HEADQUARTERS_POPULATION = 10;

  static const int WATER_PRODUCTION_RATE = 10;
  static const int FIELD_PRODUCTION_RATE = 10;
  static const int WOODCUTTER_PRODUCTION_RATE = 10;
  static const int QUARRY_PRODUCTION_RATE = 10;

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
  "zones": [],
  "colonies": []
}
''';
}
