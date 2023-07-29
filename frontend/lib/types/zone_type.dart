import 'package:gatewayguardians/utils/assets.dart';

enum ZoneType {
  grass(
    sprite: Assets.IMAGES_PATCHES_CROP_FIELD,
  ),
  desert(
    sprite: Assets.IMAGES_PATCHES_FOREST,
  ),
  snow(
    sprite: Assets.IMAGES_PATCHES_STONE_DEPOSIT,
  ),
  mountain(
    sprite: Assets.IMAGES_PATCHES_STONE_DEPOSIT,
  ),
  water(
    sprite: Assets.IMAGES_PATCHES_STONE_DEPOSIT,
  );

  final String sprite;

  const ZoneType({
    required this.sprite,
  });

  bool get canBeClaimed =>
      (this == grass) ||
      (this == desert) ||
      (this == snow) ||
      (this == mountain);

  @override
  String toString() => name.replaceAll('_', ' ');
}
