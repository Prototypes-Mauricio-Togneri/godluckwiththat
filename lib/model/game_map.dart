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
    final Offset center = _center(
      zoom: zoom,
      screenSize: WidgetsBinding.instance.window.physicalSize,
    );

    transformationController.value.setEntry(0, 0, zoom);
    transformationController.value.setEntry(1, 1, zoom);
    transformationController.value.setEntry(2, 2, zoom);
    transformationController.value.setEntry(0, 3, -center.dx);
    transformationController.value.setEntry(1, 3, -center.dy);
  }

  Offset _center({
    required double zoom,
    required Size screenSize,
  }) {
    final double xTranslate = ((dimensions.width / 2) * blockSize * zoom) - (screenSize.width / 2);
    final double yTranslate = ((dimensions.height / 2) * blockSize * zoom) - (screenSize.height / 2);

    return Offset(xTranslate, yTranslate);
  }

  Offset realToGame(Offset position) {
    final int x = (position.dx / blockSize).round();
    final int y = (position.dy / blockSize).round();

    return Offset(x - (dimensions.width / 2), y - (dimensions.height / 2));
  }
}
