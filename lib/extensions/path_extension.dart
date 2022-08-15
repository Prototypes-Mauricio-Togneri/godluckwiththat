import 'package:flutter/widgets.dart';

extension PathExtension on Path {
  void diamond({
    required Offset position,
    required num size,
  }) {
    moveTo(position.dx, position.dy - (size / 2));
    lineTo(position.dx + (size / 2), position.dy);
    lineTo(position.dx, position.dy + (size / 2));
    lineTo(position.dx - (size / 2), position.dy);
    close();
  }

  void line({
    required Offset from,
    required Offset to,
  }) {
    moveTo(from.dx, from.dy);
    lineTo(to.dx, to.dy);
  }
}
