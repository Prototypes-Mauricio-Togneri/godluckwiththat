enum ZoneStatus {
  unexplored,
  explored;

  bool get isExplored => this == explored;

  bool get isUnexplored => this == unexplored;
}
