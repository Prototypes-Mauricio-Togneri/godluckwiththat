enum ZoneStatus {
  hidden,
  unexplored,
  explored;

  bool get isHidden => this == hidden;

  bool get isUnexplored => this == unexplored;

  bool get isExplored => this == explored;

  @override
  String toString() => name.replaceAll('_', ' ');
}
