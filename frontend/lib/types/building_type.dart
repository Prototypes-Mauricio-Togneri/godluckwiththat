import 'package:tensionplanet/utils/assets.dart';

enum BuildingType {
  headquarters(sprite: Assets.IMAGES_BUILDINGS_HEADQUARTERS);

  final String sprite;

  const BuildingType({
    required this.sprite,
  });

  @override
  String toString() => name.replaceAll('_', ' ');
}
