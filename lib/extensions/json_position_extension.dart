import 'package:flutter/widgets.dart';

typedef JsonPosition = List<int>;

extension JsonPositionExtension on JsonPosition {
  int get x => this[0];

  int get y => this[1];

  Offset get position => Offset(this[0].toDouble(), this[1].toDouble());
}
