enum ZoneStatus {
  unexplored,
  explored;

  bool get isExplored => this == explored;

  bool get isUnexplored => this == unexplored;

  @override
  String toString() => name.replaceAll('_', ' ');
}
