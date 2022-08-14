import 'package:flutter/widgets.dart';

extension OffsetExtension on Offset {
  Offset nodePosition({
    required Size dimensions,
    required num blockSize,
  }) {
    final int x = (dx / blockSize).round();
    final int y = (dy / blockSize).round();

    return Offset(x - (dimensions.width / 2), y - (dimensions.height / 2));
  }
}
