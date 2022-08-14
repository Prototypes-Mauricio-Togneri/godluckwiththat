import 'package:flutter/widgets.dart';

extension OffsetExtension on Offset {
  Offset nodePosition(num blockSize) {
    final int x = (dx / blockSize).round();
    final int y = (dy / blockSize).round();

    return Offset(x.toDouble(), y.toDouble());
  }
}
