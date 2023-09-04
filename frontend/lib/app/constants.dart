class Constants {
  static const String FONT_NAME = 'CustomFont';

  static const int SECONDS_PER_DAY = 6;

  static const int HOUSE_POPULATION = 5;
  static const int HEADQUARTERS_POPULATION = 10;
  static const int BUILDING_CAPACITY_PER_LEVEL = 5;

  static const double WELL_PRODUCTION_RATE = 0.5;
  static const double FARM_PRODUCTION_RATE = 2;
  static const double WOODCUTTER_PRODUCTION_RATE = 1;
  static const double QUARRY_PRODUCTION_RATE = 0.25;

  static const double WATER_CONSUMPTION_RATE = 0.2;
  static const double FOOD_CONSUMPTION_RATE = 0.2;
  static const double WOOD_CONSUMPTION_RATE = 0.2;

  static const String EMPTY_MATCH = '''
{
	"version": 1,
	"id": "level1",
	"totalTimeElapsed": 1,
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
