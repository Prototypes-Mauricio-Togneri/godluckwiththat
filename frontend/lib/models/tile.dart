import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/patch_type.dart';
import 'package:gatewayguardians/types/tile_type.dart';

class Tile {
  final int x;
  final int y;
  final TileType tileType;
  final PatchType? patchType;
  Building? building;

  Tile({
    required this.x,
    required this.y,
    required this.tileType,
    required this.patchType,
    required this.building,
  });

  bool get hasPatch => patchType != null;

  bool hasPatchType(PatchType type) => patchType == type;

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
      (tile.id == top) ||
      (tile.id == topLeft) ||
      (tile.id == topRight) ||
      (tile.id == left) ||
      (tile.id == right) ||
      (tile.id == bottom) ||
      (tile.id == bottomLeft) ||
      (tile.id == bottomRight);

  bool isSideNeighbor(Tile tile) =>
      (tile.id == top) ||
      (tile.id == left) ||
      (tile.id == right) ||
      (tile.id == bottom);
}
