import 'package:flutter/widgets.dart';
import 'package:tensionnode/model/renderer.dart';
import 'package:tensionnode/services/palette.dart';

class Lane {
  final Offset from;
  final Offset to;

  const Lane({
    required this.from,
    required this.to,
  });

  void render(Renderer renderer) {
    renderer.line(
      from: from,
      to: to,
      color: Palette.white,
    );
  }
}
