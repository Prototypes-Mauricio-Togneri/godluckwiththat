import 'package:flutter/material.dart';

class GameMap {
  final int numberOfBlocksHorizontal;
  final int numberOfBlocksVertical;
  final int blockSize;

  const GameMap({
    required this.numberOfBlocksHorizontal,
    required this.numberOfBlocksVertical,
    required this.blockSize,
  });

  Size get dimensions => Size(
        numberOfBlocksHorizontal.toDouble(),
        numberOfBlocksVertical.toDouble(),
      );

  Size get size => Size(
        (blockSize * dimensions.width).toDouble(),
        (blockSize * dimensions.height).toDouble(),
      );

  void setCenter(TransformationController transformationController) {
    const double zoom = 5;
    final Size screenSize = WidgetsBinding.instance.window.physicalSize;
    final double xTranslate = (dimensions.width * blockSize * zoom / 2) - (screenSize.width / 2);
    final double yTranslate = (dimensions.height * blockSize * zoom / 2) - (screenSize.height / 2);

    transformationController.value.setEntry(0, 0, zoom);
    transformationController.value.setEntry(1, 1, zoom);
    transformationController.value.setEntry(2, 2, zoom);
    transformationController.value.setEntry(0, 3, -xTranslate);
    transformationController.value.setEntry(1, 3, -yTranslate);
  }

  Offset gameToReal(Offset position) => Offset(
        position.dx + ((size.width / blockSize) / 2),
        position.dy + ((size.height / blockSize) / 2),
      );

  Offset realToGame(Offset position) => Offset(
        (position.dx / blockSize).round() - (dimensions.width / 2),
        (position.dy / blockSize).round() - (dimensions.height / 2),
      );
}
