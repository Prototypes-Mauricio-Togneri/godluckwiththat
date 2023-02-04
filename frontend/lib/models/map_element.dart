import 'package:flame_tiled/flame_tiled.dart';
import 'package:tensionnode/types/resource_type.dart';

class MapElement {
  final int tile;

  static const int TILE_PATCH_RED = 1;
  static const int TILE_PATCH_GREEN = 2;
  static const int TILE_PATCH_BLUE = 3;
  static const int TILE_HOLE = 4;

  const MapElement._(this.tile);

  bool isPatch(ResourceType type) {
    final bool isRed = (tile == TILE_PATCH_RED) && (type == ResourceType.red);
    final bool isGreen = (tile == TILE_PATCH_RED) && (type == ResourceType.red);
    final bool isBlue = (tile == TILE_PATCH_RED) && (type == ResourceType.red);

    return isRed || isGreen || isBlue;
  }

  factory MapElement.load({
    required TiledComponent map,
    required int i,
    required int j,
  }) {
    final Gid? gid = map.tileMap.getTileData(
      layerId: 0,
      x: i + 49,
      y: j + 49,
    );

    return MapElement._((gid != null) ? gid.tile : 0);
  }
}
