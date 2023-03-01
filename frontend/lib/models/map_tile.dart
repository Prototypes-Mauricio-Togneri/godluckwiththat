class MapTile {
  final int _tile;

  static const int TILE_NONE = 0;
  static const int TILE_SOIL = 1;
  static const int TILE_WATER = 2;

  const MapTile(this._tile);

  bool get isSoil => _tile == TILE_SOIL;

  bool get isWater => _tile == TILE_WATER;
}
