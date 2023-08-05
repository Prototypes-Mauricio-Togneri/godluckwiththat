enum TileStatus {
  hidden,
  revealed;

  bool get isHidden => this == hidden;

  bool get isRevealed => this == revealed;

  @override
  String toString() => name.replaceAll('_', ' ');
}
