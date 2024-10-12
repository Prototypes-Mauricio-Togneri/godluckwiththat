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
}
