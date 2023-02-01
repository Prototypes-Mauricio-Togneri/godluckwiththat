typedef JsonPosition = List<int>;

extension JsonPositionExtension on JsonPosition {
  int get x => this[0];

  int get y => this[1];
}
