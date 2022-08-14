import 'package:flutter/widgets.dart';

extension PathExtension on Path {
  void diamond({
    required Offset position,
    required num blockSize,
    required num size,
  }) {
    moveTo(position.dx * blockSize, (position.dy * blockSize) - (size / 2));
    lineTo((position.dx * blockSize) + (size / 2), position.dy * blockSize);
    lineTo(position.dx * blockSize, (position.dy * blockSize) + (size / 2));
    lineTo((position.dx * blockSize) - (size / 2), position.dy * blockSize);
    close();
  }
}
