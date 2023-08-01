import 'package:gatewayguardians/utils/assets.dart';

enum TileType {
  grass(
    sprite: Assets.IMAGES_TILES_GRASS,
  ),
  /*desert(
    sprite: Assets.IMAGES_PATCHES_FOREST,
  ),
  snow(
    sprite: Assets.IMAGES_PATCHES_FOREST,
  ),*/
  water(
    sprite: Assets.IMAGES_TILES_WATER,
  );

  final String sprite;

  const TileType({
    required this.sprite,
  });

  bool get canBeClaimed => this == grass;
  //(this == desert) ||
  //(this == snow);

  bool get canExplored => this == grass;
  //(this == desert) ||
  //(this == snow);

  @override
  String toString() => name.replaceAll('_', ' ');
}
