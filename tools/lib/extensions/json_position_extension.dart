typedef JsonPosition = List<num>;

extension JsonPositionExtension on JsonPosition {
  num get x => this[0];

  num get y => this[1];
}
