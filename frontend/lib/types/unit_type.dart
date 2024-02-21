import 'package:godluckwiththat/utils/assets.dart';

enum UnitType {
  villager(sprite: Assets.IMAGES_UNITS_VILLAGER);

  final String sprite;

  const UnitType({
    required this.sprite,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
