class MapTile {
  final int _tile;

  static const int TILE_NONE = 0;
  static const int TILE_SOIL = 1;
  static const int TILE_COAL = 2;
  static const int TILE_COPPER = 3;
  static const int TILE_STONE = 4;
  static const int TILE_WATER = 5;

  const MapTile(this._tile);

  bool get isSoil => _tile == TILE_SOIL;

  bool get isCoal => _tile == TILE_COAL;

  bool get isCopper => _tile == TILE_COPPER;

  bool get isStone => _tile == TILE_STONE;

  bool get isWater => _tile == TILE_WATER;
}
