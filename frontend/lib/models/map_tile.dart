class MapTile {
  final int _tile;

  static const int TILE_NONE = 0;
  static const int TILE_GRASS = 1;
  static const int TILE_FOREST = 2;
  static const int TILE_STONE = 3;
  static const int TILE_WATER = 4;

  const MapTile(this._tile);

  bool get isGrass => _tile == TILE_GRASS;

  bool get isForest => _tile == TILE_FOREST;

  bool get isStone => _tile == TILE_STONE;

  bool get isWater => _tile == TILE_WATER;
}
