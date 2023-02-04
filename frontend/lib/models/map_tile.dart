import 'package:tensionnode/types/resource_type.dart';

class MapTile {
  final int _tile;

  static const int TILE_HOLE = 0;
  static const int TILE_PATCH_RED = 1;
  static const int TILE_PATCH_GREEN = 2;
  static const int TILE_PATCH_BLUE = 3;
  static const int TILE_GROUND = 4;

  const MapTile(this._tile);

  bool get isGround => _tile == TILE_GROUND;

  bool get isHole => _tile == TILE_HOLE;

  bool isPatch(ResourceType type) {
    final bool isRed = (_tile == TILE_PATCH_RED) && (type == ResourceType.red);
    final bool isGreen =
        (_tile == TILE_PATCH_GREEN) && (type == ResourceType.green);
    final bool isBlue =
        (_tile == TILE_PATCH_BLUE) && (type == ResourceType.blue);

    return isRed || isGreen || isBlue;
  }
}
