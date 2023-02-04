import 'package:tensionnode/types/resource_type.dart';

class MapTile {
  final int tile;

  static const int TILE_PATCH_RED = 1;
  static const int TILE_PATCH_GREEN = 2;
  static const int TILE_PATCH_BLUE = 3;
  static const int TILE_HOLE = 4;

  const MapTile(this.tile);

  bool isPatch(ResourceType type) {
    final bool isRed = (tile == TILE_PATCH_RED) && (type == ResourceType.red);
    final bool isGreen = (tile == TILE_PATCH_RED) && (type == ResourceType.red);
    final bool isBlue = (tile == TILE_PATCH_RED) && (type == ResourceType.red);

    return isRed || isGreen || isBlue;
  }
}
