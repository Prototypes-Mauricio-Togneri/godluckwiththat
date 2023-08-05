enum TileType {
  grass,
  water;

  bool get isGrass => this == grass;

  bool get isWater => this == water;

  bool get canSelected => canBeClaimed || canExplored;

  bool get canBeClaimed => this == grass;

  bool get canExplored => this == grass;

  @override
  String toString() => name.replaceAll('_', ' ');
}
