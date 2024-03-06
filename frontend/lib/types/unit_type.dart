import 'package:godluckwiththat/extensions/resource_map_extension.dart';
import 'package:godluckwiththat/types/resource_type.dart';
import 'package:godluckwiththat/utils/assets.dart';

enum UnitType {
  villager(
    sprite: Assets.IMAGES_UNITS_VILLAGER,
    cost: {
      ResourceType.food: 50,
    },
  );

  final String sprite;
  final ResourceMap cost;

  const UnitType({
    required this.sprite,
    required this.cost,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
