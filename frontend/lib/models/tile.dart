import 'package:gatewayguardians/types/tile_type.dart';
import 'package:gatewayguardians/types/type_status.dart';

class Tile {
  final int x;
  final int y;
  final TileType type;
  TileStatus status;

  Tile({
    required this.x,
    required this.y,
    required this.type,
    required this.status,
  });

  bool get isGrass => type.isGrass;

  bool get isWater => type.isWater;

  bool get isHidden => status.isHidden;

  bool get isRevealed => status.isRevealed;

  String get id => '$x,$y';

  String get top => '$x,${y - 1}';

  String get topLeft => '${x - 1},${y - 1}';

  String get topRight => '${x + 1},${y - 1}';

  String get left => '${x - 1},$y';

  String get right => '${x + 1},$y';

  String get bottom => '$x,${y + 1}';

  String get bottomLeft => '${x - 1},${y + 1}';

  String get bottomRight => '${x + 1},${y + 1}';

  bool isAnyNeighbor(Tile tile) =>
      isTopNeighbor(tile) ||
      isTopLeftNeighbor(tile) ||
      isTopRightNeighbor(tile) ||
      isBottomNeighbor(tile) ||
      isBottomLeftNeighbor(tile) ||
      isBottomRightNeighbor(tile) ||
      isLeftNeighbor(tile) ||
      isRightNeighbor(tile);

  bool isSideNeighbor(Tile tile) =>
      isTopNeighbor(tile) ||
      isBottomNeighbor(tile) ||
      isLeftNeighbor(tile) ||
      isRightNeighbor(tile);

  bool isTopNeighbor(Tile tile) => tile.id == top;

  bool isTopLeftNeighbor(Tile tile) => tile.id == topLeft;

  bool isTopRightNeighbor(Tile tile) => tile.id == topRight;

  bool isBottomNeighbor(Tile tile) => tile.id == bottom;

  bool isBottomLeftNeighbor(Tile tile) => tile.id == bottomLeft;

  bool isBottomRightNeighbor(Tile tile) => tile.id == bottomRight;

  bool isLeftNeighbor(Tile tile) => tile.id == left;

  bool isRightNeighbor(Tile tile) => tile.id == right;
}
