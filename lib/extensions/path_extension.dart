import 'package:flutter/widgets.dart';

extension PathExtension on Path {
  void diamond({
    required Offset position,
    required num size,
  }) {
    final num halfSize = size / 2;

    moveTo(position.dx, position.dy - halfSize);
    lineTo(position.dx + halfSize, position.dy);
    lineTo(position.dx, position.dy + halfSize);
    lineTo(position.dx - halfSize, position.dy);
    close();
  }

  void square({
    required Offset position,
    required num size,
  }) {
    final num halfSize = size / 2;

    moveTo(position.dx - halfSize, position.dy - halfSize);
    lineTo(position.dx + halfSize, position.dy - halfSize);
    lineTo(position.dx + halfSize, position.dy + halfSize);
    lineTo(position.dx - halfSize, position.dy + halfSize);
    close();
  }

  void line({
    required Offset from,
    required Offset to,
  }) {
    moveTo(from.dx, from.dy);
    lineTo(to.dx, to.dy);
  }

  void arrowUp({
    required Offset position,
    required num size,
  }) {
    moveTo(position.dx - size, position.dy + (size / 2));
    lineTo(position.dx, position.dy - (size / 2));
    lineTo(position.dx + size, position.dy + (size / 2));
    close();
  }

  void arrowDown({
    required Offset position,
    required num size,
  }) {
    moveTo(position.dx + size, position.dy - (size / 2));
    lineTo(position.dx, position.dy + (size / 2));
    lineTo(position.dx - size, position.dy - (size / 2));
    close();
  }

  void arrowLeft({
    required Offset position,
    required num size,
  }) {
    moveTo(position.dx + (size / 2), position.dy - size);
    lineTo(position.dx - (size / 2), position.dy);
    lineTo(position.dx + (size / 2), position.dy + size);
    close();
  }

  void arrowRight({
    required Offset position,
    required num size,
  }) {
    moveTo(position.dx - (size / 2), position.dy - size);
    lineTo(position.dx + (size / 2), position.dy);
    lineTo(position.dx - (size / 2), position.dy + size);
    close();
  }
}
