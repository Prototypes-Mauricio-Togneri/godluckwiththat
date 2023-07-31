import 'package:gatewayguardians/utils/assets.dart';

enum ZoneType {
  grass(
    sprite: Assets.IMAGES_TILES_GRASS,
  ),
  /*desert(
    sprite: Assets.IMAGES_PATCHES_FOREST,
  ),
  snow(
    sprite: Assets.IMAGES_PATCHES_FOREST,
  ),
  mountain(
    sprite: Assets.IMAGES_PATCHES_FOREST,
  ),*/
  water(
    sprite: Assets.IMAGES_TILES_WATER,
  );

  final String sprite;

  const ZoneType({
    required this.sprite,
  });

  bool get canBeClaimed => this == grass;
  //(this == desert) ||
  //(this == snow) ||
  //(this == mountain);

  @override
  String toString() => name.replaceAll('_', ' ');
}
