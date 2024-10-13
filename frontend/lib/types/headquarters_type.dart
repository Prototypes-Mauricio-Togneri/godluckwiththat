import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

enum HeadquartersType {
  camp,
  settlement,
  village,
  town,
  city;

  String get localized {
    switch (this) {
      case HeadquartersType.camp:
        return 'Camp';
      case HeadquartersType.settlement:
        return 'Settlement';
      case HeadquartersType.village:
        return 'Village';
      case HeadquartersType.town:
        return 'Town';
      case HeadquartersType.city:
        return 'City';
    }
  }

  HeadquartersType? get next {
    switch (this) {
      case HeadquartersType.camp:
        return HeadquartersType.settlement;
      case HeadquartersType.settlement:
        return HeadquartersType.village;
      case HeadquartersType.village:
        return HeadquartersType.town;
      case HeadquartersType.town:
        return HeadquartersType.city;
      case HeadquartersType.city:
        return null;
    }
  }

  ResourceMap get cost {
    switch (this) {
      case HeadquartersType.camp:
        return {
          ResourceType.wood: 100,
          ResourceType.stone: 50,
        };
      case HeadquartersType.settlement:
        return {
          ResourceType.wood: 200,
          ResourceType.stone: 100,
        };
      case HeadquartersType.village:
        return {
          ResourceType.wood: 400,
          ResourceType.stone: 200,
        };
      case HeadquartersType.town:
        return {
          ResourceType.wood: 800,
          ResourceType.stone: 400,
        };
      case HeadquartersType.city:
        return {
          ResourceType.wood: 1600,
          ResourceType.stone: 800,
        };
    }
  }

  bool canBuild(BuildingType buildingType) {
    final int requiredHeadquarters = buildingType.requires.index;

    return index >= requiredHeadquarters;
  }
}
