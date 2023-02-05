import 'package:flame/components.dart';

typedef JsonPosition = List<num>;

extension JsonPositionExtension on JsonPosition {
  num get x => this[0];

  num get y => this[1];

  Vector2 get vector => Vector2(x.toDouble(), y.toDouble());
}
